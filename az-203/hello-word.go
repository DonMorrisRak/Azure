package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"
)

func main() {
    fmt.Println("hello world")

    fmt.Println("String", randomString())
}

func randomString() string {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return strconv.Itoa(r.Int())
}