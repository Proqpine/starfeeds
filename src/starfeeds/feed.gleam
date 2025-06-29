import birl
import gleam/dict
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/option

pub type Item {
  Item(
    title: String,
    id: option.Option(String),
    url: String,
    date: birl.Time,
    description: option.Option(String),
    content: option.Option(String),
    category: option.Option(List(Category)),
    guid: option.Option(#(String, option.Option(Bool))),
    image: option.Option(String),
    audio: option.Option(String),
    video: option.Option(String),
    enclosure: option.Option(Enclosure),
    author: option.Option(List(Author)),
    contributor: option.Option(List(Author)),
    published: option.Option(birl.Time),
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

// pub fn feed(options: FeedOptions) -> Feed {
//   Feed(
//     options:,
//     items: list.new(),
//     categories: list.new(),
//     contributors: list.new(),
//     extensions: list.new(),
//   )
// }

pub fn add_item(feed: Feed, item: Item) {
  feed.items
  |> list.append([item])
}

pub fn add_category(feed: Feed, category: String) {
  feed.categories
  |> list.append([category])
}

pub fn add_contributor(feed: Feed, contributor: Author) {
  feed.contributors
  |> list.append([contributor])
}

pub fn add_extension(feed: Feed, extenstion: Extension) {
  feed.extensions
  |> list.append([extenstion])
}

pub fn link() {
  Link(href: "", rel: "", link_type: "", length: "")
}

pub fn extension() {
  Extension(name: "", objects: Photos([]))
}

pub fn enclosure() {
  Enclosure(
    url: "",
    enc_type: option.None,
    length: option.None,
    title: option.None,
    duration: option.None,
  )
}

pub fn author() {
  Author(
    name: option.None,
    email: option.None,
    url: option.None,
    avatar: option.None,
  )
}

pub type JsonFeed {
  JsonFeed(
    version: String,
    title: String,
    home_page_url: option.Option(String),
    feed_url: option.Option(String),
    description: option.Option(String),
    user_comment: option.Option(String),
    next_url: option.Option(String),
    icon: option.Option(String),
    favicon: option.Option(String),
    authors: List(Author),
    language: option.Option(String),
    expired: option.Option(Bool),
    items: List(JsonItem),
    extensions: dict.Dict(String, ExtensionObjects),
  )
}

fn json_feed_to_json(json_feed: JsonFeed) -> json.Json {
  let JsonFeed(
    version:,
    title:,
    home_page_url:,
    feed_url:,
    description:,
    user_comment:,
    next_url:,
    icon:,
    favicon:,
    authors:,
    language:,
    expired:,
    items:,
    extensions:,
  ) = json_feed
  json.object([
    #("version", json.string(version)),
    #("title", json.string(title)),
    #("home_page_url", case home_page_url {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("feed_url", case feed_url {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("description", case description {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("user_comment", case user_comment {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("next_url", case next_url {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("icon", case icon {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("favicon", case favicon {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("authors", json.array(authors, author_to_json)),
    #("language", case language {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("expired", case expired {
      option.None -> json.null()
      option.Some(value) -> json.bool(value)
    }),
    #("items", json.array(items, json_item_to_json)),
    #("extensions", extensionobject_to_json(extensions)),
  ])
}

pub type JsonItem {
  JsonItem(
    title: String,
    id: option.Option(String),
    url: String,
    date: birl.Time,
    summary: option.Option(String),
    content_html: option.Option(String),
    category: option.Option(String),
    image: option.Option(String),
    enclosure: option.Option(Enclosure),
    author: option.Option(Author),
    tags: List(String),
    date_published: String,
    date_modified: String,
    copyright: option.Option(String),
    extensions: List(dict.Dict(String, ExtensionObjects)),
  )
}

fn json_item_to_json(json_item: JsonItem) -> json.Json {
  let JsonItem(
    title:,
    id:,
    url:,
    date:,
    summary:,
    content_html:,
    category:,
    image:,
    enclosure:,
    author:,
    tags:,
    date_published:,
    date_modified:,
    copyright:,
    extensions:,
  ) = json_item
  json.object([
    #("title", json.string(title)),
    #("id", case id {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("url", json.string(url)),
    #("date", json.string(date |> birl.to_iso8601)),
    #("summary", case summary {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("content_html", case content_html {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("category", case category {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("image", case image {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("enclosure", case enclosure {
      option.None -> json.null()
      option.Some(value) -> enclosure_to_json(value)
    }),
    #("author", case author {
      option.None -> json.null()
      option.Some(value) -> author_to_json(value)
    }),
    #("tags", json.array(tags, json.string)),
    #("date_published", json.string(date_published)),
    #("date_modified", json.string(date_modified)),
    #("copyright", case copyright {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("extensions", json.array(extensions, extensionobject_to_json)),
  ])
}

pub fn new(options: FeedOptions) {
  JsonFeed(
    version: "https://jsonfeed.org/version/1.1",
    title: options.title,
    home_page_url: options.url,
    feed_url: option.None,
    description: option.None,
    user_comment: option.None,
    next_url: option.None,
    icon: option.None,
    favicon: option.None,
    authors: [],
    language: option.None,
    expired: option.None,
    items: [],
    extensions: dict.new(),
  )
}

fn feed_item() {
  JsonItem(
    title: "",
    id: option.None,
    url: "",
    date: birl.now(),
    summary: option.None,
    content_html: option.None,
    category: option.None,
    image: option.None,
    enclosure: option.None,
    author: option.None,
    tags: [],
    date_published: "",
    date_modified: "",
    copyright: option.None,
    extensions: [],
  )
}

pub fn render_json(ins: Feed) {
  let base_feed = new(ins.options)
  let feed_with_options = case ins.options {
    FeedOptions(feed_links: option.Some(links), ..) -> {
      case links.link_type {
        "Json" | "json" ->
          JsonFeed(..base_feed, feed_url: option.Some(links.href))
        _ -> base_feed
      }
    }
    _ -> base_feed
  }

  let authors = case ins.options.author {
    option.Some(author) -> [author]
    option.None -> []
  }

  let feed_with_rem_opts =
    JsonFeed(
      ..feed_with_options,
      home_page_url: ins.options.url,
      description: ins.options.description,
      icon: ins.options.image,
      authors: authors,
      language: ins.options.language,
    )

  let feed_with_extensions =
    JsonFeed(
      ..feed_with_rem_opts,
      extensions: ins.extensions
        |> list.map(fn(e) { #(e.name, e.objects) })
        |> dict.from_list,
    )

  let feed_item = feed_item()

  let final_items =
    ins.items
    |> list.map(fn(item) {
      let tags =
        item.category
        |> option.unwrap([])
        |> list.filter_map(fn(cat) { Ok(cat.name |> option.unwrap("")) })

      let extensions =
        item.extensions
        |> list.filter_map(fn(ext) {
          Ok(
            ext
            |> option.unwrap(extension()),
          )
        })
        |> list.map(fn(ext) { dict.from_list([#(ext.name, ext.objects)]) })

      let item_with_data =
        JsonItem(
          ..feed_item,
          title: item.title,
          url: item.url,
          id: item.id,
          content_html: item.content,
          summary: item.description,
          image: item.image,
          date_modified: item.date |> birl.to_iso8601,
          date_published: item.published
            |> option.unwrap(birl.now())
            |> birl.to_iso8601,
          tags: tags,
          enclosure: item.enclosure,
          extensions: extensions,
        )

      case item.author |> option.unwrap([]) |> list.first {
        Ok(author) -> JsonItem(..item_with_data, author: option.Some(author))
        Error(_) -> item_with_data
      }
    })

  let final_feed = JsonFeed(..feed_with_extensions, items: final_items)
  json_feed_to_json(final_feed)
}
