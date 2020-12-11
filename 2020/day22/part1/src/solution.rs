pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    for arg in args {
        println!("{}", arg);
    }
    Err("Not Implemented!")
}

