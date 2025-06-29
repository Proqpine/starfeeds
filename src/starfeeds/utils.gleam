import birl
import gleam/list
import gleam/option
import starfeeds/types.{Feed}

pub fn feed(options: types.FeedOptions) -> types.Feed {
  Feed(
    options:,
    items: list.new(),
    categories: list.new(),
    contributors: list.new(),
    extensions: list.new(),
  )
}

pub fn add_item(feed: types.Feed, item: types.Item) {
  feed.items
  |> list.append([item])
}

pub fn add_category(feed: types.Feed, category: String) {
  feed.categories
  |> list.append([category])
}

pub fn add_contributor(feed: types.Feed, contributor: types.Author) {
  feed.contributors
  |> list.append([contributor])
}

pub fn add_extension(feed: types.Feed, extenstion: types.Extension) {
  feed.extensions
  |> list.append([extenstion])
}

pub fn link() {
  types.Link(href: "", rel: "", link_type: "", length: "")
}

pub fn extension() {
  types.Extension(name: "", objects: types.Photos([]))
}

pub fn enclosure() {
  types.Enclosure(
    url: "",
    enc_type: option.None,
    length: option.None,
    title: option.None,
    duration: option.None,
  )
}

pub fn author() {
  types.Author(
    name: option.None,
    email: option.None,
    url: option.None,
    avatar: option.None,
  )
}
