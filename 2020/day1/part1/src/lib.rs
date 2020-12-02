pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    
    let nums: Vec<u32> = args[0]
        .trim()
        .lines()
        .map(|x| x.trim().parse::<u32>().unwrap())
        .collect();
    
    for i in 0..nums.len() {
        for j in i..nums.len() {
            if nums[i] + nums[j] == 2020 {
                return Ok((nums[i] * nums[j]).to_string());
            }
        }
    }

    Err("Something went wrong!")
}

