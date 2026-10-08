package pessoa

import (
	"context"
	"errors"

	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

var ErrNotFound = errors.New("pessoa não encontrada")

type Repository struct {
	coll *mongo.Collection
}

func NewRepository(db *mongo.Database) *Repository {
	return &Repository{coll: db.Collection("pessoas")}
}

func (r *Repository) List(ctx context.Context) ([]Pessoa, error) {
	cur, err := r.coll.Find(ctx, bson.M{}, options.Find().SetSort(bson.M{"nome": 1}))
	if err != nil {
		return nil, err
	}

	pessoas := []Pessoa{}
	if err := cur.All(ctx, &pessoas); err != nil {
		return nil, err
	}
	return pessoas, nil
}

func (r *Repository) Get(ctx context.Context, id bson.ObjectID) (Pessoa, error) {
	var p Pessoa
	err := r.coll.FindOne(ctx, bson.M{"_id": id}).Decode(&p)
	if errors.Is(err, mongo.ErrNoDocuments) {
		return p, ErrNotFound
	}
	return p, err
}

func (r *Repository) Create(ctx context.Context, nome string) (Pessoa, error) {
	p := Pessoa{ID: bson.NewObjectID(), Nome: nome}
	if _, err := r.coll.InsertOne(ctx, p); err != nil {
		return Pessoa{}, err
	}
	return p, nil
}

func (r *Repository) Update(ctx context.Context, id bson.ObjectID, nome string) (Pessoa, error) {
	res, err := r.coll.UpdateByID(ctx, id, bson.M{"$set": bson.M{"nome": nome}})
	if err != nil {
		return Pessoa{}, err
	}
	if res.MatchedCount == 0 {
		return Pessoa{}, ErrNotFound
	}
	return Pessoa{ID: id, Nome: nome}, nil
}

func (r *Repository) Delete(ctx context.Context, id bson.ObjectID) error {
	res, err := r.coll.DeleteOne(ctx, bson.M{"_id": id})
	if err != nil {
		return err
	}
	if res.DeletedCount == 0 {
		return ErrNotFound
	}
	return nil
}
