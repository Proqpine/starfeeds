import gleeunit
import gleeunit/should
import starfeeds

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn to_string_test() {
  let item =
    starfeeds.rss_item("String formatting in Go", "http://example.com/strings")
  let expected_output =
    "<item>\n<title>String formatting in Go</title>\n<description>http://example.com/strings</description>\n</item>"

  let actual_output = starfeeds.rss_item_to_xml_string(item)

  expected_output
  |> should.equal(actual_output)
}
