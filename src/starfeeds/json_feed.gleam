import birl
import gleam/dict
import gleam/list
import gleam/option
import gleam/result
import starfeeds/types
import starfeeds/utils

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

fn feed(options: types.FeedOptions) {
  JsonFeed(
    version: "https://jsonfeed.org/version/1",
    title: options.title,
    home_page_url: option.None,
    feed_url: option.None,
    description: option.None,
    user_comment: option.None,
    next_url: option.None,
    icon: option.None,
    favicon: option.None,
    authors: list.new(),
    language: option.None,
    expired: option.None,
    items: list.new(),
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
    extensions: [dict.new()],
  )
}

pub fn render_json(ins: types.Feed) {
  let feed = feed(ins.options)
  case ins.options {
    types.FeedOptions(feed_links:, ..) if feed_links != option.None -> {
      let link =
        feed_links
        |> option.then(fn(l) { option.Some(l.href) })
        |> option.unwrap("")

      let links = feed_links |> option.unwrap(utils.link())

      case links.link_type {
        "Json" | "json" -> JsonFeed(..feed, feed_url: option.Some(link))
        _ -> JsonFeed(..feed)
      }
    }
    types.FeedOptions(author:, ..) if author != option.None -> {
      let auth =
        author
        |> option.unwrap(types.Author(
          name: option.Some(""),
          email: option.Some(""),
          url: option.Some(""),
          avatar: option.Some(""),
        ))
      let authors = list.new() |> list.append([auth])

      JsonFeed(..feed, authors:)
    }
    types.FeedOptions(url:, ..) if url != option.None -> {
      JsonFeed(..feed, home_page_url: url)
    }
    types.FeedOptions(description:, ..) if description != option.None -> {
      JsonFeed(..feed, description:)
    }
    types.FeedOptions(image:, ..) if image != option.None -> {
      JsonFeed(..feed, icon: image)
    }
    types.FeedOptions(..) -> JsonFeed(..feed)
  }

  ins.extensions
  |> list.map(fn(e) { feed.extensions |> dict.insert(e.name, e.objects) })

  let feed_item = feed_item()

  feed.items
  |> list.append(
    ins.items
    |> list.map(fn(item) {
      let authors = item.author |> option.unwrap([])

      let category =
        item.category
        |> option.unwrap([])
        |> list.flat_map(fn(cat) {
          case cat.name {
            option.None -> feed_item.tags
            option.Some(name) -> feed_item.tags |> list.append([name])
          }
        })
      let extensions =
        item.extensions
        |> list.flat_map(fn(e) {
          case e {
            option.None -> feed_item.extensions
            option.Some(ext) ->
              feed_item.extensions |> dict.insert(ext.name, ext.objects)
          }
        })

      let feed_item =
        JsonItem(
          ..feed_item,
          id: item.id,
          content_html: item.content,
          summary: item.description,
          image: item.image,
          date_modified: item.date |> birl.to_iso8601,
          date_published: item.published
            |> option.unwrap(birl.now())
            |> birl.to_iso8601,
          tags: category,
          extensions: extensions,
        )

      case authors |> list.length {
        0 -> JsonItem(..feed_item)
        _ -> {
          let author = list.first(authors) |> result.unwrap(utils.author())
          JsonItem(..feed_item, author: option.Some(author))
        }
      }
    }),
  )
}
