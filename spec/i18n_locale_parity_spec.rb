require "spec_helper"

# Catches "added a Finnish string, forgot Swedish/English" at CI time.
describe "hyyvaalit locale files" do
  def flatten_keys(tree, prefix = [])
    tree.flat_map do |key, value|
      value.is_a?(Hash) ? flatten_keys(value, prefix + [key]) : [(prefix + [key]).join(".")]
    end
  end

  def keys_for(locale)
    tree = YAML.load_file(Rails.root.join("config/locales/hyyvaalit.#{locale}.yml")).fetch(locale)
    flatten_keys(tree).sort
  end

  it "has the same keys in fi, sv and en" do
    expect(keys_for("sv")).to eq(keys_for("fi"))
    expect(keys_for("en")).to eq(keys_for("fi"))
  end
end
