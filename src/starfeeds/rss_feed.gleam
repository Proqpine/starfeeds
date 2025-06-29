// pub fn rss_channel(
//   title: String,
//   description: String,
//   link: String,
// ) -> RssChannel {
//   RssChannel(
//     title: title,
//     link: link,
//     description: description,
//     language: None,
//     copyright: None,
//     managing_editor: None,
//     web_master: None,
//     pub_date: None,
//     last_build_date: None,
//     categories: [],
//     generator: None,
//     docs: None,
//     cloud: None,
//     ttl: None,
//     image: None,
//     text_input: None,
//     skip_hours: [],
//     skip_days: [],
//     items: [],
//   )
// }

// pub fn add_channel_language(channel: RssChannel, language: String) -> RssChannel {
//   RssChannel(..channel, language: Some(language))
// }

// pub fn add_channel_copyright(
//   channel: RssChannel,
//   copyright: String,
// ) -> RssChannel {
//   RssChannel(..channel, copyright: Some(copyright))
// }

// pub fn add_channel_managing_editor(
//   channel: RssChannel,
//   managing_editor: String,
// ) -> RssChannel {
//   RssChannel(..channel, managing_editor: Some(managing_editor))
// }

// pub fn add_channel_web_master(
//   channel: RssChannel,
//   web_master: String,
// ) -> RssChannel {
//   RssChannel(..channel, web_master: Some(web_master))
// }

// pub fn add_channel_pub_date(channel: RssChannel, pub_date: Time) -> RssChannel {
//   RssChannel(..channel, pub_date: Some(pub_date))
// }

// pub fn add_channel_last_build_date(
//   channel: RssChannel,
//   last_build_date: Time,
// ) -> RssChannel {
//   RssChannel(..channel, last_build_date: Some(last_build_date))
// }

// pub fn add_channel_category(channel: RssChannel, category: String) -> RssChannel {
//   RssChannel(..channel, categories: [category, ..channel.categories])
// }

// pub fn add_channel_categories(
//   channel: RssChannel,
//   categories: List(String),
// ) -> RssChannel {
//   RssChannel(
//     ..channel,
//     categories: list.concat([channel.categories, categories]),
//   )
// }

// pub fn add_channel_generator(
//   channel: RssChannel,
//   generator: String,
// ) -> RssChannel {
//   RssChannel(..channel, generator: Some(generator))
// }

// pub fn add_channel_docs(channel: RssChannel) -> RssChannel {
//   RssChannel(
//     ..channel,
//     docs: Some("https://www.rssboard.org/rss-specification"),
//   )
// }

// pub fn add_channel_cloud(channel: RssChannel, cloud: Cloud) -> RssChannel {
//   RssChannel(..channel, cloud: Some(cloud))
// }

// pub fn add_channel_ttl(channel: RssChannel, ttl: Int) -> RssChannel {
//   RssChannel(..channel, ttl: Some(ttl))
// }

// pub fn add_channel_image(channel: RssChannel, image: Image) -> RssChannel {
//   RssChannel(..channel, image: Some(image))
// }

// pub fn add_channel_text_input(
//   channel: RssChannel,
//   text_input: TextInput,
// ) -> RssChannel {
//   RssChannel(..channel, text_input: Some(text_input))
// }

// pub fn add_channel_skip_hours(
//   channel: RssChannel,
//   skip_hours: List(Int),
// ) -> RssChannel {
//   RssChannel(..channel, skip_hours: skip_hours)
// }

// pub fn add_channel_skip_days(
//   channel: RssChannel,
//   skip_days: List(birl.Weekday),
// ) -> RssChannel {
//   RssChannel(..channel, skip_days: skip_days)
// }

// pub fn add_channel_item(channel: RssChannel, item: RssItem) -> RssChannel {
//   RssChannel(..channel, items: [item, ..channel.items])
// }

// pub fn add_channel_items(
//   channel: RssChannel,
//   items: List(RssItem),
// ) -> RssChannel {
//   RssChannel(..channel, items: list.concat([channel.items, items]))
// }

// pub fn rss_item(title: String, description: String) -> RssItem {
//   RssItem(
//     title: title,
//     description: description,
//     link: None,
//     author: None,
//     source: None,
//     comments: None,
//     pub_date: None,
//     categories: [],
//     enclosure: None,
//     guid: None,
//   )
// }

// pub fn add_item_link(item: RssItem, link: String) -> RssItem {
//   RssItem(..item, link: Some(link))
// }

// pub fn add_item_author(item: RssItem, author: String) -> RssItem {
//   RssItem(..item, author: Some(author))
// }

// pub fn add_item_source(item: RssItem, source: String) -> RssItem {
//   RssItem(..item, source: Some(source))
// }

// pub fn add_item_comments(item: RssItem, comments: String) -> RssItem {
//   RssItem(..item, comments: Some(comments))
// }

// pub fn add_item_pub_date(item: RssItem, pub_date: Time) -> RssItem {
//   RssItem(..item, pub_date: Some(pub_date))
// }

// pub fn add_item_categories(item: RssItem, categories: List(String)) -> RssItem {
//   RssItem(..item, categories: categories)
// }

// pub fn add_item_enclosure(item: RssItem, enclosure: Enclosure) -> RssItem {
//   RssItem(..item, enclosure: Some(enclosure))
// }

// pub fn add_item_guid(item: RssItem, guid: #(String, Option(Bool))) -> RssItem {
//   RssItem(..item, guid: Some(guid))
// }

// pub fn rss_item_to_xml_string(item: RssItem) -> String {
//   "<item>\n"
//   <> "<title>"
//   <> item.title
//   <> "</title>\n"
//   <> "<description>"
//   <> item.description
//   <> "</description>\n"
//   <> case item.link {
//     Some(link) -> "<link>" <> link <> "</link>\n"
//     _ -> ""
//   }
//   <> case item.author {
//     Some(author) -> "<author>" <> author <> "</author>\n"
//     _ -> ""
//   }
//   <> case item.source {
//     Some(source) -> "<source>" <> source <> "</source>\n"
//     _ -> ""
//   }
//   <> case item.comments {
//     Some(comment) -> "<comments>" <> comment <> "</comments>\n"
//     _ -> ""
//   }
//   <> case item.pub_date {
//     Some(pub_date) ->
//       "<pubDate>" <> pub_date |> birl.to_iso8601 <> "</pubDate>\n"
//     _ -> ""
//   }
//   <> item.categories
//   |> list.map(fn(category) { "<category>" <> category <> "</category>\n" })
//   |> list.reduce(fn(acc, category) { acc <> category })
//   |> result.unwrap("")
//   <> case item.enclosure {
//     Some(enclosure) ->
//       "<enclosure url=\""
//       <> enclosure.url
//       <> "\" length=\""
//       <> int.to_string(enclosure.length)
//       <> "\" type=\""
//       <> enclosure.enclosure_type
//       <> "\"/>\n"
//     _ -> ""
//   }
//   <> case item.guid {
//     Some(guid) ->
//       case guid {
//         #(guid, Some(is_permalink)) ->
//           "<guid isPermaLink=\""
//           <> case is_permalink {
//             True -> "true"
//             False -> "false"
//           }
//           <> "\">"
//           <> guid
//           <> "</guid>\n"
//         _ -> ""
//       }
//     _ -> ""
//   }
//   <> "</item>"
// }

// pub fn to_xml_string(channels: List(RssChannel)) -> String {
//   let channel_ctx =
//     channels
//     |> list.map(fn(channel) { channel |> rss_channel_to_xml_string })
//     |> list.reduce(fn(acc, channel_str) { acc <> "\n" <> channel_str })
//     |> result.unwrap("")
//   "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0.1\">"
//   <> channel_ctx
//   <> "\n</rss>"
// }

// pub fn rss_channel_to_xml_string(channel: RssChannel) -> String {
//   let channel_items: String =
//     channel.items
//     |> list.map(fn(rss_item) { rss_item |> rss_item_to_xml_string })
//     |> list.reduce(fn(acc, rss_item_to_xml_string) {
//       acc <> "\n" <> rss_item_to_xml_string
//     })
//     |> result.unwrap("")
//   "\n<channel>\n"
//   <> "<title>"
//   <> channel.title
//   <> "</title>\n"
//   <> "<link>"
//   <> channel.link
//   <> "</link>\n"
//   <> "<description>"
//   <> channel.description
//   <> "</description>\n"
//   <> case channel.language {
//     Some(language) -> "<language>" <> language <> "</language>\n"
//     _ -> ""
//   }
//   <> case channel.copyright {
//     Some(copyright) -> "<copyright>" <> copyright <> "</copyright>\n"
//     _ -> ""
//   }
//   <> case channel.managing_editor {
//     Some(managing_editor) ->
//       "<managing_editor>" <> managing_editor <> "</managing_editor>\n"
//     _ -> ""
//   }
//   <> case channel.web_master {
//     Some(web_master) -> "<web_master>" <> web_master <> "</web_master>\n"
//     _ -> ""
//   }
//   <> case channel.pub_date {
//     Some(pub_date) ->
//       "<pubDate>" <> pub_date |> birl.to_iso8601 <> "</pubDate>\n"
//     _ -> ""
//   }
//   <> case channel.last_build_date {
//     Some(last_build_date) ->
//       "<lastBuildDate>"
//       <> last_build_date |> birl.to_iso8601
//       <> "</lastBuildDate>\n"
//     _ -> ""
//   }
//   <> channel.categories
//   |> list.map(fn(category) { "<category>" <> category <> "</category>\n" })
//   |> list.reduce(fn(acc, category) { acc <> category })
//   |> result.unwrap("")
//   <> case channel.generator {
//     Some(generator) -> "<generator>" <> generator <> "</generator>\n"
//     _ -> ""
//   }
//   <> case channel.docs {
//     Some(docs) -> "<docs>" <> docs <> "</docs>\n"
//     _ -> ""
//   }
//   <> case channel.cloud {
//     Some(cloud) ->
//       "<cloud domain=\""
//       <> cloud.domain
//       <> "\" port=\""
//       <> int.to_string(cloud.port)
//       <> "\" path=\""
//       <> cloud.path
//       <> "\" registerProcedure=\""
//       <> cloud.register_procedure
//       <> "\" protocol=\""
//       <> cloud.protocol
//       <> "\" />\n"
//     _ -> ""
//   }
//   <> case channel.ttl {
//     Some(ttl) -> "<docs>" <> int.to_string(ttl) <> "</docs>\n"
//     _ -> ""
//   }
//   <> case channel.image {
//     Some(image) ->
//       "<image>"
//       <> "<url>"
//       <> image.url
//       <> "</url>\n"
//       <> "<title>"
//       <> image.title
//       <> "</title>\n"
//       <> "<link>"
//       <> image.link
//       <> "</link>\n"
//       <> case image.description {
//         Some(description) ->
//           "<description>" <> description <> "</description>\n"
//         _ -> ""
//       }
//       <> case image.width {
//         Some(width) -> "<width>" <> int.to_string(width) <> "</width>\n"
//         _ -> ""
//       }
//       <> case image.height {
//         Some(height) -> "<height>" <> int.to_string(height) <> "</height>\n"
//         _ -> ""
//       }
//       <> "</image>\n"
//     _ -> ""
//   }
//   <> case channel.text_input {
//     Some(text_input) ->
//       "<textInput>"
//       <> "<title>"
//       <> text_input.title
//       <> "</title>\n"
//       <> "<description>"
//       <> text_input.description
//       <> "</description>\n"
//       <> "<name>"
//       <> text_input.name
//       <> "</name>\n"
//       <> "<link>"
//       <> text_input.link
//       <> "</link>\n"
//       <> "</textInput>\n"
//     _ -> ""
//   }
//   <> case channel.skip_hours |> list.length > 0 {
//     True -> {
//       "<skipHours>"
//       <> list.map(channel.skip_hours, fn(hour) {
//         "<hour>" <> int.to_string(hour) <> "</hour>"
//       })
//       |> list.reduce(fn(acc, hour) { acc <> "\n" <> hour })
//       |> result.unwrap("")
//     }
//     _ -> ""
//   }
//   <> case channel.skip_days |> list.length > 0 {
//     True -> {
//       "<skipDays>"
//       <> list.map(channel.skip_days, fn(day) {
//         "<day>" <> day |> birl.weekday_to_string <> "</day>"
//       })
//       |> list.reduce(fn(acc, day) { acc <> "\n" <> day })
//       |> result.unwrap("")
//       <> "</skipDays>\n"
//     }
//     _ -> ""
//   }
//   <> channel_items
//   <> "</channel>"
// }
