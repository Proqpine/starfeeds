import birl
import gleam/list
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import starfeeds

pub fn main() {
  gleeunit.main()
}

// Test JsonAuthor
pub fn json_author_test() {
  let author =
    starfeeds.JsonAuthor(
      "John Doe",
      "https://example.com",
      Some("https://example.com/avatar.jpg"),
    )
  author.name |> should.equal("John Doe")
  author.url |> should.equal("https://example.com")
  author.avatar |> should.equal(Some("https://example.com/avatar.jpg"))
}

// Test attachment_to_json
pub fn attachment_to_json_test() {
  let attachment =
    starfeeds.JsonAttachment(
      "https://example.com/file.pdf",
      "application/pdf",
      "Example PDF",
      Some(1024),
      None,
    )
  let result = starfeeds.attachment_to_json(attachment)
  result
  |> should.equal(
    "{\"url\":\"https://example.com/file.pdf\",\"mime_type\":\"application/pdf\",\"title\":\"Example PDF\",\"size_in_bytes\":1024}",
  )
}

// Test json_item_to_string
pub fn json_item_to_string_test() {
  let item = starfeeds.json_item("1", "https://example.com", "Example Title")
  let result = starfeeds.json_item_to_string(item)
  result
  |> should.equal(
    "{\"id\":\"1\",\"url\":\"https://example.com\",\"title\":\"Example Title\"}",
  )
}

// Test json_item and its modifiers
pub fn test_json_item_and_modifiers() {
  let item =
    starfeeds.json_item("1", "https://example.com", "Example Title")
    |> starfeeds.add_json_item_external_url("https://external.com")
    |> starfeeds.add_json_item_content_html("<p>HTML content</p>")
    |> starfeeds.add_json_item_content_text("Plain text content")
    |> starfeeds.add_json_item_summary("Summary")
    |> starfeeds.add_json_item_image("https://example.com/image.jpg")
    |> starfeeds.add_json_item_banner_image("https://example.com/banner.jpg")
    |> starfeeds.add_json_item_date_published(birl.now())
    |> starfeeds.add_json_item_date_modified(birl.now())
    |> starfeeds.add_json_item_author(starfeeds.JsonAuthor(
      "John Doe",
      "https://example.com",
      None,
    ))
    |> starfeeds.add_json_item_tags(["tag1", "tag2"])
    |> starfeeds.add_json_item_language("en")
    |> starfeeds.add_json_item_attachment(starfeeds.JsonAttachment(
      "https://example.com/file.pdf",
      "application/pdf",
      "Example PDF",
      Some(1024),
      None,
    ))
  item.id |> should.equal("1")
  item.url |> should.equal("https://example.com")
  item.title |> should.equal("Example Title")
  item.external_url |> should.equal(Some("https://external.com"))
  item.content_html |> should.equal(Some("<p>HTML content</p>"))
  item.content_text |> should.equal(Some("Plain text content"))
  item.summary |> should.equal(Some("Summary"))
  item.image |> should.equal(Some("https://example.com/image.jpg"))
  item.banner_image |> should.equal(Some("https://example.com/banner.jpg"))
  item.date_published
  |> should.equal(Some(birl.now()))
  item.date_modified
  |> should.equal(Some(birl.now()))
  item.authors |> list.length |> should.equal(1)
  item.tags |> should.equal(["tag1", "tag2"])
  item.language |> should.equal(Some("en"))
  item.attachments |> list.length |> should.equal(1)
}

// Test json_feed
pub fn test_json_test() {
  let feed = starfeeds.json_feed("1.0", "Example Feed")
  feed.version |> should.equal("1.0")
  feed.title |> should.equal("Example Feed")
}

// Test rss_channel and its modifiers
pub fn rss_channel_and_modifiers_test() {
  let channel =
    starfeeds.rss_channel(
      "Example Channel",
      "Channel Description",
      "https://example.com",
    )
    |> starfeeds.add_channel_language("en")
    |> starfeeds.add_channel_copyright("Copyright 2023")
    |> starfeeds.add_channel_managing_editor("editor@example.com")
    |> starfeeds.add_channel_web_master("webmaster@example.com")
    |> starfeeds.add_channel_pub_date(birl.from_unix(1_313_654_602))
    |> starfeeds.add_channel_last_build_date(birl.from_unix(1_313_654_602))
    |> starfeeds.add_channel_category("Technology")
    |> starfeeds.add_channel_generator("Example Generator")
    |> starfeeds.add_channel_docs()
    |> starfeeds.add_channel_cloud(starfeeds.Cloud(
      "example.com",
      80,
      "/rpc",
      "pingMe",
      "soap",
    ))
    |> starfeeds.add_channel_ttl(60)
    |> starfeeds.add_channel_image(starfeeds.Image(
      "https://example.com/image.jpg",
      "Image Title",
      "https://example.com",
      None,
      None,
      None,
    ))
    |> starfeeds.add_channel_text_input(starfeeds.TextInput(
      "Search",
      "Search the site",
      "q",
      "https://example.com/search",
    ))
    |> starfeeds.add_channel_skip_hours([0, 1, 2])
    |> starfeeds.add_channel_skip_days([birl.Mon, birl.Tue])
    |> starfeeds.add_channel_item(starfeeds.rss_item(
      "Item Title",
      "Item Description",
    ))

  channel.title |> should.equal("Example Channel")
  channel.description |> should.equal("Channel Description")
  channel.link |> should.equal("https://example.com")
  channel.language |> should.equal(Some("en"))
  channel.copyright |> should.equal(Some("Copyright 2023"))
  channel.managing_editor |> should.equal(Some("editor@example.com"))
  channel.web_master |> should.equal(Some("webmaster@example.com"))
  channel.pub_date
  |> should.equal(Some(birl.from_unix(1_313_654_602)))
  channel.last_build_date
  |> should.equal(Some(birl.from_unix(1_313_654_602)))
  channel.categories |> should.equal(["Technology"])
  channel.generator |> should.equal(Some("Example Generator"))
  channel.docs
  |> should.equal(Some("https://www.rssboard.org/rss-specification"))
  channel.ttl |> should.equal(Some(60))
  channel.skip_hours |> should.equal([0, 1, 2])
  channel.skip_days |> should.equal([birl.Mon, birl.Tue])
  channel.items |> list.length |> should.equal(1)
}

// Test rss_item and its modifiers
pub fn rss_item_and_modifiers_test() {
  let item =
    starfeeds.rss_item("Item Title", "Item Description")
    |> starfeeds.add_item_link("https://example-gleam.com/item")
    |> starfeeds.add_item_author("John Doe")
    |> starfeeds.add_item_source("Original Source")
    |> starfeeds.add_item_comments("https://example.com/item/comments")
    |> starfeeds.add_item_pub_date(birl.from_unix(1_313_654_602))
    |> starfeeds.add_item_categories(["Category1", "Category2"])
    |> starfeeds.add_item_enclosure(starfeeds.Enclosure(
      "https://example.com/file.mp3",
      1024,
      "audio/mpeg",
    ))
    |> starfeeds.add_item_guid(#("https://example.com/item", Some(True)))

  item.title |> should.equal("Item Title")
  item.description |> should.equal("Item Description")
  item.link |> should.equal(Some("https://example-gleam.com/item"))
  item.author |> should.equal(Some("John Doe"))
  item.source |> should.equal(Some("Original Source"))
  item.comments |> should.equal(Some("https://example.com/item/comments"))
  item.pub_date |> should.equal(Some(birl.from_unix(1_313_654_602)))
  item.categories |> should.equal(["Category1", "Category2"])
  item.guid |> should.equal(Some(#("https://example.com/item", Some(True))))
}

// // Test to_xml_string
pub fn to_xml_string_test() {
  let channel =
    starfeeds.rss_channel(
      "Example Channel",
      "Channel Description",
      "https://example.com",
    )
    |> starfeeds.add_channel_item(starfeeds.rss_item(
      "Item Title",
      "Item Description",
    ))
  let result = starfeeds.to_xml_string([channel])
  result
  |> should.equal(
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0.1\">\n<channel>\n<title>Example Channel</title>\n<link>https://example.com</link>\n<description>Channel Description</description>\n<item>\n<title>Item Title</title>\n<description>Item Description</description>\n</item></channel>\n</rss>",
  )
}

// Test rss_channel_to_xml_string
pub fn rss_channel_to_xml_string_test() {
  let channel =
    starfeeds.rss_channel(
      "Example Channel",
      "Channel Description",
      "https://example.com",
    )
  let result = starfeeds.rss_channel_to_xml_string(channel)
  result
  |> should.equal(
    "\n<channel>\n<title>Example Channel</title>\n<link>https://example.com</link>\n<description>Channel Description</description>\n</channel>",
  )
}

// Test rss_item_to_xml_string
pub fn rss_item_to_xml_string_test() {
  let item = starfeeds.rss_item("Item Title", "Item Description")
  let result = starfeeds.rss_item_to_xml_string(item)
  result
  |> should.equal(
    "<item>\n<title>Item Title</title>\n<description>Item Description</description>\n</item>",
  )
}
