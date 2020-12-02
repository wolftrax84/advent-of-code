pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let nums: Vec<u32> = args[0]
        .trim()
        .lines()
        .map(|x| x.trim().parse::<u32>().unwrap())
        .collect();
    
    for i in 0..nums.len() {
        for j in i..nums.len() {
            for k in j..nums.len() {
                if nums[i] + nums[j] + nums[k]== 2020 {
                    return Ok((nums[i] * nums[j] * nums[k]).to_string());
                }
            }
        }
    }

    Err("Something went wrong!")
}

