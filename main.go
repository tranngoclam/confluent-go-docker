package main

import (
	"fmt"

	"github.com/confluentinc/confluent-kafka-go/v2/kafka"
)

func main() {
	vnum, vstr := kafka.LibraryVersion()
	fmt.Printf("LibraryVersion: %s (0x%x)\n", vstr, vnum)
	fmt.Printf("LinkInfo:       %s\n", kafka.LibrdkafkaLinkInfo)
}
