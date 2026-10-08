package pessoa

import "go.mongodb.org/mongo-driver/v2/bson"

type Pessoa struct {
	ID   bson.ObjectID `json:"id" bson:"_id,omitempty"`
	Nome string        `json:"nome" bson:"nome"`
}

type Input struct {
	Nome string `json:"nome"`
}
