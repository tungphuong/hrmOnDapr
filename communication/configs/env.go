package configs

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

func Init() {
	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

func EnvPostgresConnStr() string {
	return os.Getenv("DB_CONN_STRING")
}

func EnableDapr() bool {
	enableDapr, _ := strconv.ParseBool(os.Getenv("ENABLE_DAPR"))
	return enableDapr
}
