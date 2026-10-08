package pessoa

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"strings"

	"go.mongodb.org/mongo-driver/v2/bson"
)

type Handler struct {
	repo *Repository
}

func NewHandler(repo *Repository) *Handler {
	return &Handler{repo: repo}
}

func (h *Handler) Register(mux *http.ServeMux) {
	mux.HandleFunc("GET /pessoas", h.list)
	mux.HandleFunc("GET /pessoas/{id}", h.get)
	mux.HandleFunc("POST /pessoas", h.create)
	mux.HandleFunc("PUT /pessoas/{id}", h.update)
	mux.HandleFunc("DELETE /pessoas/{id}", h.delete)
}

func (h *Handler) list(w http.ResponseWriter, r *http.Request) {
	pessoas, err := h.repo.List(r.Context())
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, pessoas)
}

func (h *Handler) get(w http.ResponseWriter, r *http.Request) {
	id, ok := parseID(w, r)
	if !ok {
		return
	}
	p, err := h.repo.Get(r.Context(), id)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, p)
}

func (h *Handler) create(w http.ResponseWriter, r *http.Request) {
	nome, ok := parseInput(w, r)
	if !ok {
		return
	}
	p, err := h.repo.Create(r.Context(), nome)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, p)
}

func (h *Handler) update(w http.ResponseWriter, r *http.Request) {
	id, ok := parseID(w, r)
	if !ok {
		return
	}
	nome, ok := parseInput(w, r)
	if !ok {
		return
	}
	p, err := h.repo.Update(r.Context(), id, nome)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, p)
}

func (h *Handler) delete(w http.ResponseWriter, r *http.Request) {
	id, ok := parseID(w, r)
	if !ok {
		return
	}
	if err := h.repo.Delete(r.Context(), id); err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func parseID(w http.ResponseWriter, r *http.Request) (bson.ObjectID, bool) {
	id, err := bson.ObjectIDFromHex(r.PathValue("id"))
	if err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"erro": "id inválido"})
		return id, false
	}
	return id, true
}

func parseInput(w http.ResponseWriter, r *http.Request) (string, bool) {
	var in Input
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"erro": "json inválido"})
		return "", false
	}
	nome := strings.TrimSpace(in.Nome)
	if nome == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{"erro": "nome é obrigatório"})
		return "", false
	}
	return nome, true
}

func writeError(w http.ResponseWriter, err error) {
	if errors.Is(err, ErrNotFound) {
		writeJSON(w, http.StatusNotFound, map[string]string{"erro": err.Error()})
		return
	}
	log.Printf("erro interno: %v", err)
	writeJSON(w, http.StatusInternalServerError, map[string]string{"erro": "erro interno"})
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}
