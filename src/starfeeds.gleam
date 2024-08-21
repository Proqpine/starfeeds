import birl.{type Time}
import gleam/option.{type Option, None}

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
    comments: Option(String),
    source: Option(String),
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
    link: Link,
    description: String,
    language: Option(String),
    copyright: Option(String),
    managing_editor: Option(String),
    web_master: Option(String),
    /// Publication Date of the content in RFC 822
    pub_date: Option(Time),
    last_build_date: Option(Time),
    categories: List(String),
    generator: Option(String),
    docs: Option(String),
    cloud: Option(Cloud),
    ttl: Option(Int),
    image: Option(Image),
    text_input: Option(TextInput),
    skip_hours: Option(Int),
    skip_days: List(birl.Weekday),
  )
}

pub fn rss_channel(title: String, description: String, link: Link) -> RssChannel {
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
    skip_hours: None,
    skip_days: [],
  )
}

pub fn rss_item(title: String, description: String) -> RssItem {
  RssItem(
    title: title,
    description: description,
    link: None,
    author: None,
    comments: None,
    source: None,
    pub_date: None,
    categories: [],
    enclosure: None,
    guid: None,
  )
}
