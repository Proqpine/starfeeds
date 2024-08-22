import birl.{type Time}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

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
