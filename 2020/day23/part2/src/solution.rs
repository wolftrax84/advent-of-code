const SIZE: u64 = 1000000;

struct Cups {
    current: u64,
    list: Vec<u64>
}

impl Cups {
    fn new(input: &String) -> Cups {
        let thing: Vec<u64>;
        thing = input.trim().chars().map(|c| c.to_string().parse::<u64>().unwrap()).collect::<Vec<u64>>();
        let current = thing[0];
        let mut list: Vec<u64> = Vec::new();
        list.resize(SIZE as usize+1, 0);
        for (i, c) in (&thing).into_iter().enumerate() {
            list[*c as usize] = if i as usize == thing.len()-1 {thing.len() as u64 + 1} else {thing[(i+1) as usize]};
        }
        for i in thing.len()+1..SIZE as usize {
            list[i] = i as u64 + 1;
        }
        list[SIZE as usize] = current;
        Cups {
            current,
            list
        }
    }

    fn make_move(&mut self) {
        let three_cups = self.pull_three_cups();
        let mut destination = self.current;
        while three_cups.contains(&destination) || destination == self.current {
            destination -= 1;
            if destination == 0 {
                destination = SIZE;
            }
        }
        self.list[three_cups[2] as usize] = self.list[destination as usize];
        self.list[destination as usize] = three_cups[0];
        self.current = self.list[self.current as usize];
    }

    fn pull_three_cups(&mut self) -> Vec<u64> {
        let mut three_cups: Vec<u64> = Vec::new();
        three_cups.push(self.list[self.current as usize]);
        three_cups.push(self.list[three_cups[0] as usize]);
        three_cups.push(self.list[(three_cups[1]) as usize]);
        self.list[self.current as usize] = self.list[three_cups[2] as usize];
        three_cups
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut thing = Cups::new(&args[0]);

    for _i in 0..10000000 {
        thing.make_move();
    }

    let first_index = thing.list[1];
    let second_index = thing.list[first_index as usize];
    let result = first_index * second_index;
    Ok(result.to_string())
}
