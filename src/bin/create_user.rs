extern crate cs_cityio_backend;
extern crate diesel;

use cs_cityio_backend::{connect, create_user};
use cs_cityio_backend::models::Table;
use crate::diesel::prelude::*;

use serde_json::json;

fn main() {
    let connection = connect();

    // need base variable
    let user = create_user(&connection, &base, true);

    println!("\n saved user {} with id {}", &user.username, &user.id);
}
