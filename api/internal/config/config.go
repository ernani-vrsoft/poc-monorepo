package config

import "os"

type Config struct {
	Port     string
	MongoURI string
	MongoDB  string
}

func Load() Config {
	return Config{
		Port:     getEnv("PORT", "12001"),
		MongoURI: getEnv("MONGO_URI", "mongodb://localhost:27018"),
		MongoDB:  getEnv("MONGO_DB", "poc"),
	}
}

func getEnv(key, fallback string) string {
	if v, ok := os.LookupEnv(key); ok && v != "" {
		return v
	}
	return fallback
}
