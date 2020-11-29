# https://github.com/stedolan/jq/blob/master/src/builtin.jq#L284
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;


def underscore_keys:
  . | walk(
    if type == "object" then
      with_entries(
        if .key | test("(-|/)") then
           .key |= gsub("(-|/)";"_")
        else .
        end
     )
   else .
   end
  );

def remove_empty:
  . | walk(
    if type == "object" then
      with_entries(
        select(
          .value != null and
          .value != "" and
          .value != [] and
          .value != {}
        )
      )
    else .
    end
  );

def with_urls:
  . | walk(
    if type == "object" then
      with_entries(
        select(
          .value | (type == "object" or
               type == "array" or
               (type == "string" and match("http","i"))
               )
        )
      )
    else .
    end
  );
