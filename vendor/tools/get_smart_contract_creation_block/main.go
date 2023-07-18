package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"math/big"
	"sync"
	"time"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
)

var (
	ethereumNodeURL      = flag.String("ethereum_node_url", "", "Ethereum node URL used for requests")
	smartContractAddress = flag.String("smart_contract_address", "", "Smart contract address used to get its block height")
)

type ContractFinder struct {
	client      *ethclient.Client
	latestBlock int64
}

func NewContractFinder(provider string) (*ContractFinder, error) {
	conn, err := ethclient.Dial(provider)
	if err != nil {
		return nil, err
	}
	latestBlock, err := conn.BlockByNumber(context.Background(), nil)
	if err != nil {
		return nil, err
	}

	return &ContractFinder{
		client:      conn,
		latestBlock: latestBlock.Number().Int64(),
	}, nil
}

func (c *ContractFinder) codeLen(contractAddr string, blockNumber int64) int {
	ticker := time.NewTicker(time.Millisecond * 500)
	load := time.NewTicker(time.Millisecond * 100)
	timeout := time.After(time.Second * 10)

	for {
		select {
		case <-ticker.C:
			ticker.Stop()

			data, err := c.client.CodeAt(context.Background(), common.HexToAddress(contractAddr), big.NewInt(blockNumber))
			if err == nil {
				return len(data)
			}

			ticker.Reset(time.Millisecond * 500)
		case <-timeout:
			return 0
		case <-load.C:
		}
	}
}

func (c *ContractFinder) GetContractCreationBlock(contractAddr string) int64 {
	return c.getCreationBlock(contractAddr, 0, c.latestBlock)
}

func (c *ContractFinder) getCreationBlock(contractAddr string, startBlock int64, endBlock int64) int64 {
	if startBlock == endBlock {
		return startBlock
	}
	midBlock := (startBlock + endBlock) / 2
	codeLen := c.codeLen(contractAddr, midBlock)
	if codeLen > 2 {
		return c.getCreationBlock(contractAddr, startBlock, midBlock)
	} else {
		return c.getCreationBlock(contractAddr, midBlock+1, endBlock)
	}
}

type Data struct {
	address    string
	startBlock int64
}

func worker(cttFinder *ContractFinder, contractChan <-chan Data, resultChan chan<- Data) {
	for data := range contractChan {
		creationBlock := cttFinder.GetContractCreationBlock(data.address)
		resultChan <- Data{data.address, creationBlock}
	}
}

func init() {
	flag.Parse()
}

func main() {
	if len(*ethereumNodeURL) == 0 {
		log.Fatal("Ethereum node URL is required to be specified by 'ethereum_node_url' param")
	}

	cttFinder, err := NewContractFinder(*ethereumNodeURL)
	if err != nil {
		log.Fatal("Whoops something went wrong!", err)
	}

	inputChan := make(chan Data)
	resultChan := make(chan Data)

	go func() {
		inputChan <- Data{*smartContractAddress, 0}
	}()

	var wg sync.WaitGroup
	numberWorkers := 10
	for i := 0; i < numberWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			worker(cttFinder, inputChan, resultChan)
		}()
	}

	go func() {
		wg.Wait()
		close(resultChan)
	}()

	fmt.Print((<-resultChan).startBlock)
}
