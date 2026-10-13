# Pokedex

A terminal-based Pokédex. Look up Pokémon by number, name, or region.

## Usage

./pokedex.sh 25          # by dex number
./pokedex.sh pikachu     # by name (case-insensitive)
./pokedex.sh kanto       # list every Pokémon in a region

## Data

- `data/pokemon.csv` — the 151 Kanto Pokémon: number, name, types, height, weight, and dex description (sourced from PokeAPI)
- `data/regions.csv` — dex number ranges for each region

## Requirements

bash and awk. That's it.
