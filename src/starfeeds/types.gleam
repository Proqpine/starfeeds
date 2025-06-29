import birl.{type Time}
import gleam/dynamic
import gleam/list
import gleam/option.{type Option}

pub type Item {
  Item(
    title: String,
    id: option.Option(String),
    url: String,
    date: Time,
    description: option.Option(String),
    content: option.Option(String),
    category: option.Option(List(Category)),
    guid: option.Option(#(String, option.Option(Bool))),
    image: option.Option(String),
    audio: option.Option(String),
    video: option.Option(String),
    enclosure: Option(Enclosure),
    author: option.Option(List(Author)),
    contributor: option.Option(List(Author)),
    published: option.Option(Time),
    copyright: option.Option(String),
    extensions: List(option.Option(Extension)),
  )
}

pub type Enclosure {
  Enclosure(
    url: String,
    enc_type: option.Option(String),
    length: option.Option(Int),
    title: option.Option(String),
    duration: option.Option(Int),
  )
}

pub type Author {
  Author(
    name: option.Option(String),
    email: option.Option(String),
    url: option.Option(String),
    avatar: option.Option(String),
  )
}

pub type Category {
  Category(
    name: option.Option(String),
    domain: option.Option(String),
    scheme: option.Option(String),
    term: option.Option(String),
  )
}

pub type Link {
  Link(href: String, rel: String, link_type: String, length: String)
}

pub type FeedOptions {
  FeedOptions(
    id: String,
    title: String,
    updated: option.Option(Time),
    generator: option.Option(String),
    language: option.Option(String),
    ttl: option.Option(Int),
    feed: option.Option(String),
    feed_links: option.Option(Link),
    hub: option.Option(String),
    docs: option.Option(String),
    podcast: option.Option(Bool),
    category: option.Option(String),
    author: option.Option(Author),
    url: option.Option(String),
    description: option.Option(String),
    image: option.Option(String),
    favicon: option.Option(String),
    copyright: option.Option(String),
  )
}

pub type Photo {
  Photo(id: Int, url: String, caption: String)
}

pub type Video {
  Video(id: Int, title: String, duration_seconds: Int)
}

pub type ExtensionObjects {
  Photos(List(Photo))
  Videos(List(Video))
  UnknownObjects(dynamic.Dynamic)
}

pub type Extension {
  Extension(name: String, objects: ExtensionObjects)
}

pub type Feed {
  Feed(
    options: FeedOptions,
    items: List(Item),
    categories: List(String),
    contributors: List(Author),
    extensions: List(Extension),
  )
}
