import birl.{type Time}
import gleam/dict
import gleam/dynamic
import gleam/json
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

pub fn enclosure_to_json(enclosure: Enclosure) -> json.Json {
  let Enclosure(url:, enc_type:, length:, title:, duration:) = enclosure
  json.object([
    #("url", json.string(url)),
    #("enc_type", case enc_type {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("length", case length {
      option.None -> json.null()
      option.Some(value) -> json.int(value)
    }),
    #("title", case title {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("duration", case duration {
      option.None -> json.null()
      option.Some(value) -> json.int(value)
    }),
  ])
}

pub type Author {
  Author(
    name: option.Option(String),
    email: option.Option(String),
    url: option.Option(String),
    avatar: option.Option(String),
  )
}

pub fn author_to_json(author: Author) -> json.Json {
  let Author(name:, email:, url:, avatar:) = author
  json.object([
    #("name", case name {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("email", case email {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("url", case url {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("avatar", case avatar {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
  ])
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
    updated: option.Option(birl.Time),
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

pub fn photo_to_json(photo: Photo) -> json.Json {
  let Photo(id:, url:, caption:) = photo
  json.object([
    #("id", json.int(id)),
    #("url", json.string(url)),
    #("caption", json.string(caption)),
  ])
}

pub type Video {
  Video(id: Int, title: String, duration_seconds: Int)
}

pub fn video_to_json(video: Video) -> json.Json {
  let Video(id:, title:, duration_seconds:) = video
  json.object([
    #("id", json.int(id)),
    #("title", json.string(title)),
    #("duration_seconds", json.int(duration_seconds)),
  ])
}

pub fn extensionobject_to_json(object: dict.Dict(String, ExtensionObjects)) {
  object
  |> dict.to_list
  |> list.map(fn(kv) {
    let #(key, value) = kv
    let out = case value {
      Photos(photo_list) -> json.array(from: photo_list, of: photo_to_json)
      Videos(video_list) -> json.array(from: video_list, of: video_to_json)
      UnknownObjects(_) -> {
        let unknown_list = [json.object([#("any", json.null())])]
        json.array(from: unknown_list, of: fn(j) { j })
      }
    }
    #(key, out)
  })
  |> json.object
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
