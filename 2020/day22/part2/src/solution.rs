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
    let winner: (usize, VecDeque<u16>) = play_game(decks.clone());
    dbg!(&winner);
    let mut result = 0;
    for (index, card) in winner.1.iter().enumerate() {
        result += *card as usize * (&winner.1.len() - index)
    }
    Ok(result.to_string())
}

fn play_game(mut decks: Vec<VecDeque<u16>>) -> (usize, VecDeque<u16>) {
    let mut prev_states: Vec<String> = Vec::new();
    while decks[0].len() > 0 && decks[1].len() > 0 {
        let cards = (decks[0].pop_front().unwrap(), decks[1].pop_front().unwrap());        
        if cards.0 as usize <= decks[0].len() && cards.1 as usize <= decks[1].len() {
            let mut sub_decks = decks.clone();
            sub_decks[0].truncate(cards.0 as usize);
            sub_decks[1].truncate(cards.1 as usize);
            let winner = play_game(sub_decks);
            decks[winner.0].push_back(if winner.0 == 0 {cards.0} else {cards.1});
            decks[winner.0].push_back(if winner.0 == 0 {cards.1} else {cards.0});
        } else {
            let winner = if cards.0 > cards.1 { 0 } else { 1 };
            decks[winner].push_back(cmp::max(cards.0, cards.1));
            decks[winner].push_back(cmp::min(cards.0, cards.1));
        }
        let next_state = get_state_from_decks(&decks);
        if prev_states.contains(&next_state) {
            return (0, decks[0].clone());
        } else {
            prev_states.push(next_state);
        }
    }
    return if decks[0] > decks[1] {(0, decks[0].clone())} else {(1, decks[1].clone())};
}

fn get_state_from_decks(decks: &Vec<VecDeque<u16>>) -> String {
    let mut result = String::new();
    for deck in decks {
        for card in deck {
            result.push_str(&card.to_string());
        }
        result.push('|');
    }
    result
}
