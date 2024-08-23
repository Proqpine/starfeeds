import birl.{type Time}
import gleam/int
import gleam/json.{array, int, object, string}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

fn json_item_to_string(item: JsonItem) -> json.Json {
  [
    #("id", string(item.id)),
    #("url", string(item.url)),
    case item.external_url {
      Some(external_url) if external_url != "" -> #(
        "external_url",
        string(external_url),
      )
      _ -> #("", string(""))
    },
    #("title", json.string(item.title)),
    case item.content_html {
      Some(content_html) if content_html != "" -> #(
        "content_html",
        string(content_html),
      )
      _ -> #("", string(""))
    },
    case item.content_text {
      Some(content_text) if content_text != "" -> #(
        "content_text",
        string(content_text),
      )
      _ -> #("", string(""))
    },
    case item.summary {
      Some(summary) if summary != "" -> #("summary", string(summary))
      _ -> #("", string(""))
    },
    case item.image {
      Some(image) if image != "" -> #("image", string(image))
      _ -> #("", string(""))
    },
    case item.banner_image {
      Some(banner_image) if banner_image != "" -> #(
        "banner_image",
        string(banner_image),
      )
      _ -> #("", string(""))
    },
    case item.date_published {
      Some(date_published) -> #(
        "date_published",
        string(birl.to_date_string(date_published)),
      )
      _ -> #("", string(""))
    },
    case item.date_modified {
      Some(date_modified) -> #(
        "date_modified",
        string(birl.to_date_string(date_modified)),
      )
      _ -> #("", string(""))
    },
    case item.authors {
      [] -> #("", string(""))
      authors -> #(
        "authors",
        array(authors, fn(a) {
          object([
            #("name", string(a.name)),
            #("url", string(a.url)),
            #(
              "avatar",
              string(case a.avatar {
                Some(avatar) if avatar != "" -> avatar
                _ -> ""
              }),
            ),
          ])
        }),
      )
    },
    case item.tags {
      [] -> #("", string(""))
      tags -> #("tags", array(tags, string))
    },
    case item.language {
      Some(language) if language != "" -> #("language", string(language))
      _ -> #("", string(""))
    },
    case item.attachments {
      [] -> #("", string(""))
      attachments -> #(
        "attachments",
        array(attachments, fn(attach) {
          object([
            #("url", string(attach.url)),
            #("mime_type", string(attach.mime_type)),
            #("title", string(attach.title)),
            #(
              "size_in_bytes",
              int(case attach.size_in_bytes {
                Some(size_in_bytes) if size_in_bytes >= 0 -> size_in_bytes
                _ -> 0
              }),
            ),
            #(
              "duration_in_seconds",
              int(case attach.duration_in_seconds {
                Some(duration_in_seconds) if duration_in_seconds >= 0 ->
                  duration_in_seconds
                _ -> 0
              }),
            ),
          ])
        }),
      )
    },
  ]
  |> list.filter(fn(pair) { pair.0 != "" })
  |> object()
}

pub fn json_feed_to_string(feed: JsonFeed) -> String {
  [
    #("version", string(feed.version)),
    #("title", string(feed.title)),
    case feed.home_page_url {
      Some(url) -> #("home_page_url", string(url))
      _ -> #("", string(""))
    },
    case feed.feed_url {
      Some(url) -> #("feed_url", string(url))
      _ -> #("", string(""))
    },
    case feed.description {
      Some(desc) -> #("description", string(desc))
      _ -> #("", string(""))
    },
    case feed.user_comment {
      Some(comment) -> #("user_comment", string(comment))
      _ -> #("", string(""))
    },
    case feed.next_url {
      Some(url) -> #("next_url", string(url))
      _ -> #("", string(""))
    },
    case feed.icon {
      Some(icon) -> #("icon", string(icon))
      _ -> #("", string(""))
    },
    case feed.favicon {
      Some(favicon) -> #("favicon", string(favicon))
      _ -> #("", string(""))
    },
    case feed.authors {
      [] -> #("", string(""))
      authors -> #(
        "authors",
        array(authors, fn(a) {
          object([
            #("name", string(a.name)),
            #("url", string(a.url)),
            #(
              "avatar",
              string(case a.avatar {
                Some(avatar) if avatar != "" -> avatar
                _ -> ""
              }),
            ),
          ])
        }),
      )
    },
    case feed.language {
      Some(lang) -> #("language", string(lang))
      _ -> #("", string(""))
    },
    case feed.expired {
      Some(expired) -> #("expired", json.bool(expired))
      _ -> #("", string(""))
    },
    #("items", array(feed.items, fn(item) { json_item_to_string(item) })),
  ]
  |> list.filter(fn(pair) { pair.0 != "" })
  |> object()
  |> json.to_string
}

pub type JsonAuthor {
  JsonAuthor(name: String, url: String, avatar: Option(String))
}

pub type JsonAttachment {
  JsonAttachment(
    url: String,
    mime_type: String,
    title: String,
    size_in_bytes: Option(Int),
    duration_in_seconds: Option(Int),
  )
}

pub type JsonItem {
  JsonItem(
    id: String,
    url: String,
    external_url: Option(String),
    title: String,
    content_html: Option(String),
    content_text: Option(String),
    summary: Option(String),
    image: Option(String),
    banner_image: Option(String),
    date_published: Option(Time),
    date_modified: Option(Time),
    authors: List(JsonAuthor),
    tags: List(String),
    language: Option(String),
    attachments: List(JsonAttachment),
  )
}

pub type JsonFeed {
  JsonFeed(
    version: String,
    title: String,
    home_page_url: Option(String),
    feed_url: Option(String),
    description: Option(String),
    user_comment: Option(String),
    next_url: Option(String),
    icon: Option(String),
    favicon: Option(String),
    authors: List(JsonAuthor),
    language: Option(String),
    expired: Option(Bool),
    items: List(JsonItem),
  )
}

/// Rss Types ---------------------------------------------------------------------------------
//---------------------

/// Link of an Rss Channel
pub type Link {
  Link(href: String, rel: String, link_type: String, length: String)
}

pub type Image {
  Image(
    url: String,
    title: String,
    link: String,
    description: Option(String),
    width: Option(Int),
    height: Option(Int),
  )
}

pub type Cloud {
  Cloud(
    domain: String,
    port: Int,
    path: String,
    register_procedure: String,
    protocol: String,
  )
}

pub type TextInput {
  TextInput(title: String, description: String, name: String, link: String)
}

pub type Enclosure {
  Enclosure(url: String, length: Int, enclosure_type: String)
}

pub type RssItem {
  RssItem(
    title: String,
    description: String,
    link: Option(String),
    author: Option(String),
    source: Option(String),
    comments: Option(String),
    pub_date: Option(Time),
    categories: List(String),
    enclosure: Option(Enclosure),
    guid: Option(#(String, Option(Bool))),
  )
}

/// RSS 2.0. Compliant Spec
pub type RssChannel {
  RssChannel(
    title: String,
    link: String,
    description: String,
    language: Option(String),
    copyright: Option(String),
    managing_editor: Option(String),
    web_master: Option(String),
    /// Publication Date of the content in RFC 822 Date-time format
    pub_date: Option(Time),
    last_build_date: Option(Time),
    categories: List(String),
    generator: Option(String),
    docs: Option(String),
    cloud: Option(Cloud),
    ttl: Option(Int),
    image: Option(Image),
    text_input: Option(TextInput),
    skip_hours: List(Int),
    skip_days: List(birl.Weekday),
    items: List(RssItem),
  )
}

pub fn to_xml_string(channels: List(RssChannel)) -> String {
  let channel_ctx =
    channels
    |> list.map(fn(channel) { channel |> rss_channel_to_xml_string })
    |> list.reduce(fn(acc, channel_str) { acc <> "\n" <> channel_str })
    |> result.unwrap("")
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0.1\">"
  <> channel_ctx
  <> "\n</rss>"
}

pub fn rss_channel_to_xml_string(channel: RssChannel) -> String {
  let channel_items: String =
    channel.items
    |> list.map(fn(rss_item) { rss_item |> rss_item_to_xml_string })
    |> list.reduce(fn(acc, rss_item_to_xml_string) {
      acc <> "\n" <> rss_item_to_xml_string
    })
    |> result.unwrap("")
  "\n<channel>\n"
  <> "<title>"
  <> channel.title
  <> "</title>\n"
  <> "<link>"
  <> channel.link
  <> "</link>\n"
  <> "<description>"
  <> channel.description
  <> "</description>\n"
  <> case channel.language {
    Some(language) -> "<language>" <> language <> "</language>\n"
    _ -> ""
  }
  <> case channel.copyright {
    Some(copyright) -> "<copyright>" <> copyright <> "</copyright>\n"
    _ -> ""
  }
  <> case channel.managing_editor {
    Some(managing_editor) ->
      "<managing_editor>" <> managing_editor <> "</managing_editor>\n"
    _ -> ""
  }
  <> case channel.web_master {
    Some(web_master) -> "<web_master>" <> web_master <> "</web_master>\n"
    _ -> ""
  }
  <> case channel.pub_date {
    Some(pub_date) ->
      "<pubDate>" <> pub_date |> birl.to_iso8601 <> "</pubDate>\n"
    _ -> ""
  }
  <> case channel.last_build_date {
    Some(last_build_date) ->
      "<lastBuildDate>"
      <> last_build_date |> birl.to_iso8601
      <> "</lastBuildDate>\n"
    _ -> ""
  }
  <> channel.categories
  |> list.map(fn(category) { "<category>" <> category <> "</category>\n" })
  |> list.reduce(fn(acc, category) { acc <> category })
  |> result.unwrap("")
  <> case channel.generator {
    Some(generator) -> "<generator>" <> generator <> "</generator>\n"
    _ -> ""
  }
  <> case channel.docs {
    Some(docs) -> "<docs>" <> docs <> "</docs>\n"
    _ -> ""
  }
  <> case channel.cloud {
    Some(cloud) ->
      "<cloud domain=\""
      <> cloud.domain
      <> "\" port=\""
      <> int.to_string(cloud.port)
      <> "\" path=\""
      <> cloud.path
      <> "\" registerProcedure=\""
      <> cloud.register_procedure
      <> "\" protocol=\""
      <> cloud.protocol
      <> "\" />\n"
    _ -> ""
  }
  <> case channel.ttl {
    Some(ttl) -> "<docs>" <> int.to_string(ttl) <> "</docs>\n"
    _ -> ""
  }
  <> case channel.image {
    Some(image) ->
      "<image>"
      <> "<url>"
      <> image.url
      <> "</url>\n"
      <> "<title>"
      <> image.title
      <> "</title>\n"
      <> "<link>"
      <> image.link
      <> "</link>\n"
      <> case image.description {
        Some(description) ->
          "<description>" <> description <> "</description>\n"
        _ -> ""
      }
      <> case image.width {
        Some(width) -> "<width>" <> int.to_string(width) <> "</width>\n"
        _ -> ""
      }
      <> case image.height {
        Some(height) -> "<height>" <> int.to_string(height) <> "</height>\n"
        _ -> ""
      }
      <> "</image>\n"
    _ -> ""
  }
  <> case channel.text_input {
    Some(text_input) ->
      "<textInput>"
      <> "<title>"
      <> text_input.title
      <> "</title>\n"
      <> "<description>"
      <> text_input.description
      <> "</description>\n"
      <> "<name>"
      <> text_input.name
      <> "</name>\n"
      <> "<link>"
      <> text_input.link
      <> "</link>\n"
      <> "</textInput>\n"
    _ -> ""
  }
  <> case channel.skip_hours |> list.length > 0 {
    True -> {
      "<skipHours>"
      <> list.map(channel.skip_hours, fn(hour) {
        "<hour>" <> int.to_string(hour) <> "</hour>"
      })
      |> list.reduce(fn(acc, hour) { acc <> "\n" <> hour })
      |> result.unwrap("")
    }
    _ -> ""
  }
  <> case channel.skip_days |> list.length > 0 {
    True -> {
      "<skipDays>"
      <> list.map(channel.skip_days, fn(day) {
        "<day>" <> day |> birl.weekday_to_string <> "</day>"
      })
      |> list.reduce(fn(acc, day) { acc <> "\n" <> day })
      |> result.unwrap("")
      <> "</skipDays>\n"
    }
    _ -> ""
  }
  <> channel_items
  <> "</channel>"
}

pub fn rss_item_to_xml_string(item: RssItem) -> String {
  "<item>\n"
  <> "<title>"
  <> item.title
  <> "</title>\n"
  <> "<description>"
  <> item.description
  <> "</description>\n"
  <> case item.link {
    Some(link) -> "<link>" <> link <> "</link>\n"
    _ -> ""
  }
  <> case item.author {
    Some(author) -> "<author>" <> author <> "</author>\n"
    _ -> ""
  }
  <> case item.source {
    Some(source) -> "<source>" <> source <> "</source>\n"
    _ -> ""
  }
  <> case item.comments {
    Some(comment) -> "<comments>" <> comment <> "</comments>\n"
    _ -> ""
  }
  <> case item.pub_date {
    Some(pub_date) ->
      "<pubDate>" <> pub_date |> birl.to_iso8601 <> "</pubDate>\n"
    _ -> ""
  }
  <> item.categories
  |> list.map(fn(category) { "<category>" <> category <> "</category>\n" })
  |> list.reduce(fn(acc, category) { acc <> category })
  |> result.unwrap("")
  <> case item.enclosure {
    Some(enclosure) ->
      "<enclosure url=\""
      <> enclosure.url
      <> "\" length=\""
      <> int.to_string(enclosure.length)
      <> "\" type=\""
      <> enclosure.enclosure_type
      <> "\"/>\n"
    _ -> ""
  }
  <> case item.guid {
    Some(guid) ->
      case guid {
        #(guid, Some(is_permalink)) ->
          "<guid isPermaLink=\""
          <> case is_permalink {
            True -> "true"
            False -> "false"
          }
          <> "\">"
          <> guid
          <> "</guid>\n"
        _ -> ""
      }
    _ -> ""
  }
  <> "</item>"
}

pub fn json_item(id: String, url: String, title: String) -> JsonItem {
  JsonItem(
    id: id,
    url: url,
    external_url: None,
    title: title,
    content_html: None,
    content_text: None,
    summary: None,
    image: None,
    banner_image: None,
    date_published: None,
    date_modified: None,
    authors: [],
    tags: [],
    language: None,
    attachments: [],
  )
}

pub fn add_json_item_external_url(
  item: JsonItem,
  external_url: String,
) -> JsonItem {
  JsonItem(..item, external_url: Some(external_url))
}

pub fn add_json_item_content_html(
  item: JsonItem,
  content_html: String,
) -> JsonItem {
  JsonItem(..item, content_html: Some(content_html))
}

pub fn add_json_item_content_text(
  item: JsonItem,
  content_text: String,
) -> JsonItem {
  JsonItem(..item, content_text: Some(content_text))
}

pub fn add_json_item_summary(item: JsonItem, summary: String) -> JsonItem {
  JsonItem(..item, summary: Some(summary))
}

pub fn add_json_item_image(item: JsonItem, image: String) {
  JsonItem(..item, image: Some(image))
}

pub fn add_json_item_banner_image(
  item: JsonItem,
  banner_image: String,
) -> JsonItem {
  JsonItem(..item, banner_image: Some(banner_image))
}

pub fn add_json_item_date_published(
  item: JsonItem,
  date_published: Time,
) -> JsonItem {
  JsonItem(..item, date_published: Some(date_published))
}

pub fn add_json_item_date_modified(
  item: JsonItem,
  date_modified: Time,
) -> JsonItem {
  JsonItem(..item, date_modified: Some(date_modified))
}

pub fn add_json_item_author(item: JsonItem, author: JsonAuthor) -> JsonItem {
  JsonItem(..item, authors: [author, ..item.authors])
}

pub fn add_json_item_authors(
  item: JsonItem,
  authors: List(JsonAuthor),
) -> JsonItem {
  JsonItem(..item, authors: list.concat([item.authors, authors]))
}

pub fn add_json_item_tags(item: JsonItem, tags: List(String)) -> JsonItem {
  JsonItem(..item, tags: tags)
}

pub fn add_json_item_language(item: JsonItem, language: String) -> JsonItem {
  JsonItem(..item, language: Some(language))
}

pub fn add_json_item_attachment(
  item: JsonItem,
  attachment: JsonAttachment,
) -> JsonItem {
  JsonItem(..item, attachments: [attachment, ..item.attachments])
}

pub fn add_json_item_attachments(
  item: JsonItem,
  attachments: List(JsonAttachment),
) -> JsonItem {
  JsonItem(..item, attachments: list.concat([item.attachments, attachments]))
}

pub fn json_feed(version: String, title: String) -> JsonFeed {
  JsonFeed(
    version: version,
    title: title,
    home_page_url: None,
    feed_url: None,
    description: None,
    user_comment: None,
    next_url: None,
    icon: None,
    favicon: None,
    authors: [],
    language: None,
    expired: None,
    items: [],
  )
}

pub fn rss_channel(
  title: String,
  description: String,
  link: String,
) -> RssChannel {
  RssChannel(
    title: title,
    link: link,
    description: description,
    language: None,
    copyright: None,
    managing_editor: None,
    web_master: None,
    pub_date: None,
    last_build_date: None,
    categories: [],
    generator: None,
    docs: None,
    cloud: None,
    ttl: None,
    image: None,
    text_input: None,
    skip_hours: [],
    skip_days: [],
    items: [],
  )
}

pub fn add_channel_language(channel: RssChannel, language: String) -> RssChannel {
  RssChannel(..channel, language: Some(language))
}

pub fn add_channel_copyright(
  channel: RssChannel,
  copyright: String,
) -> RssChannel {
  RssChannel(..channel, copyright: Some(copyright))
}

pub fn add_channel_managing_editor(
  channel: RssChannel,
  managing_editor: String,
) -> RssChannel {
  RssChannel(..channel, managing_editor: Some(managing_editor))
}

pub fn add_channel_web_master(
  channel: RssChannel,
  web_master: String,
) -> RssChannel {
  RssChannel(..channel, web_master: Some(web_master))
}

pub fn add_channel_pub_date(channel: RssChannel, pub_date: Time) -> RssChannel {
  RssChannel(..channel, pub_date: Some(pub_date))
}

pub fn add_channel_last_build_date(
  channel: RssChannel,
  last_build_date: Time,
) -> RssChannel {
  RssChannel(..channel, last_build_date: Some(last_build_date))
}

pub fn add_channel_category(channel: RssChannel, category: String) -> RssChannel {
  RssChannel(..channel, categories: [category, ..channel.categories])
}

pub fn add_channel_categories(
  channel: RssChannel,
  categories: List(String),
) -> RssChannel {
  RssChannel(
    ..channel,
    categories: list.concat([channel.categories, categories]),
  )
}

pub fn add_channel_generator(
  channel: RssChannel,
  generator: String,
) -> RssChannel {
  RssChannel(..channel, generator: Some(generator))
}

pub fn add_channel_docs(channel: RssChannel) -> RssChannel {
  RssChannel(
    ..channel,
    docs: Some("https://www.rssboard.org/rss-specification"),
  )
}

pub fn add_channel_cloud(channel: RssChannel, cloud: Cloud) -> RssChannel {
  RssChannel(..channel, cloud: Some(cloud))
}

pub fn add_channel_ttl(channel: RssChannel, ttl: Int) -> RssChannel {
  RssChannel(..channel, ttl: Some(ttl))
}

pub fn add_channel_image(channel: RssChannel, image: Image) -> RssChannel {
  RssChannel(..channel, image: Some(image))
}

pub fn add_channel_text_input(
  channel: RssChannel,
  text_input: TextInput,
) -> RssChannel {
  RssChannel(..channel, text_input: Some(text_input))
}

pub fn add_channel_skip_hours(
  channel: RssChannel,
  skip_hours: List(Int),
) -> RssChannel {
  RssChannel(..channel, skip_hours: skip_hours)
}

pub fn add_channel_skip_days(
  channel: RssChannel,
  skip_days: List(birl.Weekday),
) -> RssChannel {
  RssChannel(..channel, skip_days: skip_days)
}

pub fn add_channel_item(channel: RssChannel, item: RssItem) -> RssChannel {
  RssChannel(..channel, items: [item, ..channel.items])
}

pub fn add_channel_items(
  channel: RssChannel,
  items: List(RssItem),
) -> RssChannel {
  RssChannel(..channel, items: list.concat([channel.items, items]))
}

pub fn rss_item(title: String, description: String) -> RssItem {
  RssItem(
    title: title,
    description: description,
    link: None,
    author: None,
    source: None,
    comments: None,
    pub_date: None,
    categories: [],
    enclosure: None,
    guid: None,
  )
}

pub fn add_item_link(item: RssItem, link: String) -> RssItem {
  RssItem(..item, link: Some(link))
}

pub fn add_item_author(item: RssItem, author: String) -> RssItem {
  RssItem(..item, author: Some(author))
}

pub fn add_item_source(item: RssItem, source: String) -> RssItem {
  RssItem(..item, source: Some(source))
}

pub fn add_item_comments(item: RssItem, comments: String) -> RssItem {
  RssItem(..item, comments: Some(comments))
}

pub fn add_item_pub_date(item: RssItem, pub_date: Time) -> RssItem {
  RssItem(..item, pub_date: Some(pub_date))
}

pub fn add_item_categories(item: RssItem, categories: List(String)) -> RssItem {
  RssItem(..item, categories: categories)
}

pub fn add_item_enclosure(item: RssItem, enclosure: Enclosure) -> RssItem {
  RssItem(..item, enclosure: Some(enclosure))
}

pub fn add_item_guid(item: RssItem, guid: #(String, Option(Bool))) -> RssItem {
  RssItem(..item, guid: Some(guid))
}
