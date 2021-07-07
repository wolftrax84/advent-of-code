use std::collections::VecDeque;
use std::cmp;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut decks: Vec<VecDeque<u16>> = Vec::new();
    let player_inputs = args[0].split("\r\n\r\n").collect::<Vec<&str>>();
    for player_input in player_inputs {
        let mut deck_input = player_input.split(":").collect::<Vec<&str>>()[1].split("\r\n").collect::<Vec<&str>>();
        deck_input.retain(|s| *s != "");
        decks.push(deck_input.iter().map(|s| s.parse::<u16>().unwrap()).collect::<VecDeque<u16>>().clone());
    }

    while decks[0].len() > 0 && decks[1].len() > 0 {
        let cards = (decks[0].pop_front().unwrap(), decks[1].pop_front().unwrap());
        let winner = if cards.0 > cards.1 { 0 } else { 1 };
        decks[winner].push_back(cmp::max(cards.0, cards.1));
        decks[winner].push_back(cmp::min(cards.0, cards.1));
    }
    let winning_deck = if decks[0] > decks[1] {decks[0].clone()} else {decks[1].clone()};
    let mut result = 0;
    for (index, card) in winning_deck.iter().enumerate() {
        result += *card as usize * (&winning_deck.len() - index)
    }
    Ok(result.to_string())
}
