import birl
import birl/duration
import gleam/json
import gleam/option
import gleeunit
import gleeunit/should
import starfeeds/feed

pub fn main() {
  gleeunit.main()
}

pub fn render_json_with_basic_feed_test() {
  let feed_options =
    feed.FeedOptions(
      id: "tag:example.com,2025:feed/1",
      title: "My Basic Feed",
      updated: option.None,
      generator: option.None,
      language: option.Some("en-US"),
      ttl: option.None,
      feed: option.None,
      feed_links: option.None,
      hub: option.None,
      docs: option.None,
      podcast: option.None,
      category: option.None,
      author: option.None,
      url: option.None,
      description: option.None,
      image: option.None,
      favicon: option.None,
      copyright: option.None,
    )

  let input_feed =
    feed.Feed(
      options: feed_options,
      items: [],
      categories: [],
      contributors: [],
      extensions: [],
    )

  let actual_json = feed.render_json(input_feed)

  let expected_json =
    json.object([
      #("version", json.string("https://jsonfeed.org/version/1.1")),
      #("title", json.string("My Basic Feed")),
      #("home_page_url", json.null()),
      #("feed_url", json.null()),
      #("description", json.null()),
      #("user_comment", json.null()),
      #("next_url", json.null()),
      #("icon", json.null()),
      #("favicon", json.null()),
      #("authors", json.array(from: [], of: fn(x) { x })),
      #("language", json.string("en-US")),
      #("expired", json.null()),
      #("items", json.array(from: [], of: fn(x) { x })),
      #("extensions", json.object([])),
    ])

  should.equal(actual_json, expected_json)
}

pub fn render_json_with_items_and_extensions_test() {
  let now = birl.now()
  // Approx 2025-06-28
  let later = birl.now() |> birl.add(duration.Duration(30))

  // 1. ARRANGE
  let feed_options =
    feed.FeedOptions(
      id: "tag:example.com,2025:feed/2",
      title: "My Rich Feed",
      url: option.Some("https://example.com"),
      description: option.Some("A feed with everything"),
      author: option.Some(feed.Author(
        name: option.Some("Feed Author"),
        url: option.Some("https://author.com"),
        email: option.None,
        avatar: option.None,
      )),
      // ... other options
      updated: option.None,
      generator: option.None,
      language: option.None,
      ttl: option.None,
      feed: option.None,
      feed_links: option.None,
      hub: option.None,
      docs: option.None,
      podcast: option.None,
      category: option.None,
      image: option.None,
      favicon: option.None,
      copyright: option.None,
    )

  let input_item =
    feed.Item(
      title: "Hello, World!",
      id: option.Some("tag:example.com,2025:item/1"),
      url: "https://example.com/hello",
      date: later,
      published: option.Some(now),
      content: option.Some("<p>This is the content.</p>"),
      description: option.Some("A summary"),
      image: option.Some("https://example.com/image.png"),
      author: option.Some([
        feed.Author(
          name: option.Some("Item Author"),
          url: option.None,
          email: option.None,
          avatar: option.None,
        ),
      ]),
      category: option.Some([
        feed.Category(
          name: option.Some("tech"),
          domain: option.None,
          scheme: option.None,
          term: option.None,
        ),
        feed.Category(
          name: option.Some("gleam"),
          domain: option.None,
          scheme: option.None,
          term: option.None,
        ),
      ]),
      extensions: [
        option.Some(feed.Extension(
          name: "_special_photo",
          objects: feed.Photos([
            feed.Photo(id: 1, url: "photo_url", caption: "a caption"),
          ]),
        )),
      ],
      // ... other options
      guid: option.None,
      audio: option.None,
      video: option.None,
      enclosure: option.None,
      contributor: option.None,
      copyright: option.None,
    )

  let input_feed =
    feed.Feed(
      options: feed_options,
      items: [input_item],
      categories: [],
      contributors: [],
      extensions: [
        feed.Extension(
          name: "_top_level",
          objects: feed.Videos([
            feed.Video(id: 10, title: "Top Video", duration_seconds: 120),
          ]),
        ),
      ],
    )

  // 2. ACT
  let actual_json = feed.render_json(input_feed)

  // 3. ASSERT
  let expected_json =
    json.object([
      #("version", json.string("https://jsonfeed.org/version/1.1")),
      #("title", json.string("My Rich Feed")),
      #("home_page_url", json.string("https://example.com")),
      #("feed_url", json.null()),
      #("description", json.string("A feed with everything")),
      #("user_comment", json.null()),
      #("next_url", json.null()),
      #("icon", json.null()),
      #("favicon", json.null()),
      #(
        "authors",
        json.array(
          from: [
            feed.author_to_json(feed.Author(
              name: option.Some("Feed Author"),
              url: option.Some("https://author.com"),
              email: option.None,
              avatar: option.None,
            )),
          ],
          of: fn(j) { j },
        ),
      ),
      #("language", json.null()),
      #("expired", json.null()),
      #(
        "items",
        json.array(
          from: [
            json.object([
              #("title", json.string("Hello, World!")),
              #("id", json.string("tag:example.com,2025:item/1")),
              #("url", json.string("https://example.com/hello")),
              #("date", json.string(birl.to_iso8601(later))),
              #("summary", json.string("A summary")),
              #("content_html", json.string("<p>This is the content.</p>")),
              #("category", json.null()),
              #("image", json.string("https://example.com/image.png")),
              #("enclosure", json.null()),
              #(
                "author",
                feed.author_to_json(feed.Author(
                  name: option.Some("Item Author"),
                  url: option.None,
                  email: option.None,
                  avatar: option.None,
                )),
              ),
              #("tags", json.array(from: ["tech", "gleam"], of: json.string)),
              #("date_published", json.string(birl.to_iso8601(now))),
              #("date_modified", json.string(birl.to_iso8601(later))),
              #("copyright", json.null()),
              #(
                "extensions",
                json.array(
                  from: [
                    json.object([
                      #(
                        "_special_photo",
                        json.array(
                          from: [
                            feed.photo_to_json(feed.Photo(
                              id: 1,
                              url: "photo_url",
                              caption: "a caption",
                            )),
                          ],
                          of: fn(j) { j },
                        ),
                      ),
                    ]),
                  ],
                  of: fn(j) { j },
                ),
              ),
            ]),
          ],
          of: fn(j) { j },
        ),
      ),
      #(
        "extensions",
        json.object([
          #(
            "_top_level",
            json.array(
              from: [
                feed.video_to_json(feed.Video(
                  id: 10,
                  title: "Top Video",
                  duration_seconds: 120,
                )),
              ],
              of: fn(j) { j },
            ),
          ),
        ]),
      ),
    ])

  should.equal(actual_json, expected_json)
}
