import birl
import gleam/io
import gleam/option.{None, Some}
import simplifile
import starfeeds.{
  type JsonFeed, type JsonItem, add_json_item_content_html,
  add_json_item_date_published, json_feed_to_string, json_item,
}

pub fn main() {
  let feed = create_blog_feed()
  let json_string = json_feed_to_string(feed)

  case simplifile.write("blog_feed.json", json_string) {
    Ok(_) -> io.println("Blog feed JSON file created successfully!")
    Error(_) -> io.println("Error writing file: ")
  }
}

fn create_blog_feed() -> JsonFeed {
  starfeeds.JsonFeed(
    version: "https://jsonfeed.org/version/1.1",
    title: "My Awesome Blog",
    home_page_url: Some("https://myblog.example.com"),
    feed_url: Some("https://myblog.example.com/feed.json"),
    description: Some("A blog about awesome things"),
    user_comment: Some("This is a JSON Feed for my blog"),
    next_url: None,
    icon: Some("https://myblog.example.com/icon.png"),
    favicon: Some("https://myblog.example.com/favicon.ico"),
    authors: [
      starfeeds.JsonAuthor(
        name: "Jane Doe",
        url: "https://myblog.example.com/about",
        avatar: Some("https://myblog.example.com/janedoe.jpg"),
      ),
    ],
    language: Some("en"),
    expired: Some(False),
    items: [
      create_blog_post(
        "1",
        "My First Blog Post",
        "<h1>Welcome to my blog!</h1><p>This is my very first blog post. I'm excited to share my thoughts with you all!</p>",
      ),
      create_blog_post(
        "2",
        "Learning Gleam",
        "<h1>My Journey with Gleam</h1><p>I've been learning Gleam, and it's been an amazing experience. Here are some of my thoughts...</p>",
      ),
      create_blog_post(
        "3",
        "JSON Feed Implementation",
        "<h1>Implementing JSON Feed in Gleam</h1><p>Today, I'll walk you through how I implemented JSON Feed for my blog using Gleam...</p>",
      ),
    ],
  )
}

fn create_blog_post(id: String, title: String, content: String) -> JsonItem {
  json_item(id, "https://myblog.example.com/posts/" <> id, title)
  |> add_json_item_content_html(content)
  |> add_json_item_date_published(birl.now())
}
