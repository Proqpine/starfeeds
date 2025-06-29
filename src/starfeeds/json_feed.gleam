import birl
import gleam/dict
import gleam/json
import gleam/list
import gleam/option
import starfeeds/feed
import starfeeds/types

pub opaque type JsonFeed {
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
    authors: List(types.Author),
    language: option.Option(String),
    expired: option.Option(Bool),
    items: List(JsonItem),
    extensions: dict.Dict(String, types.ExtensionObjects),
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
    #("authors", json.array(authors, types.author_to_json)),
    #("language", case language {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("expired", case expired {
      option.None -> json.null()
      option.Some(value) -> json.bool(value)
    }),
    #("items", json.array(items, json_item_to_json)),
    #("extensions", types.extensionobject_to_json(extensions)),
  ])
}

pub opaque type JsonItem {
  JsonItem(
    title: String,
    id: option.Option(String),
    url: String,
    date: birl.Time,
    summary: option.Option(String),
    content_html: option.Option(String),
    category: option.Option(String),
    image: option.Option(String),
    enclosure: option.Option(types.Enclosure),
    author: option.Option(types.Author),
    tags: List(String),
    date_published: String,
    date_modified: String,
    copyright: option.Option(String),
    extensions: List(dict.Dict(String, types.ExtensionObjects)),
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
      option.Some(value) -> types.enclosure_to_json(value)
    }),
    #("author", case author {
      option.None -> json.null()
      option.Some(value) -> types.author_to_json(value)
    }),
    #("tags", json.array(tags, json.string)),
    #("date_published", json.string(date_published)),
    #("date_modified", json.string(date_modified)),
    #("copyright", case copyright {
      option.None -> json.null()
      option.Some(value) -> json.string(value)
    }),
    #("extensions", json.array(extensions, types.extensionobject_to_json)),
  ])
}

fn feed(options: types.FeedOptions) {
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

pub fn render_json(ins: types.Feed) {
  let base_feed = feed(ins.options)
  let feed_with_options = case ins.options {
    types.FeedOptions(feed_links: option.Some(links), ..) -> {
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
            |> option.unwrap(feed.extension()),
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
