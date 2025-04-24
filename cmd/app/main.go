package main

import (
	"fmt"

	"github.com/go-faker/faker/v4"
)

func main() {
	fmt.Printf("Hello, %s!", faker.Name())
}
