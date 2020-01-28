# frozen_string_literal: true

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Import google bigtable client lib
require "google/cloud/bigtable"

# [START bigtable_reads_row]
def reads_row project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  row = table.read_row "phone#4c410523#20190501"
  print_row row
end

# [END bigtable_reads_row]

# [START bigtable_reads_row_partial]
def reads_row_partial project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id
  filter = Google::Cloud::Bigtable::RowFilter.qualifier "os_build"

  row = table.read_row "phone#4c410523#20190501", filter: filter
  print_row row
end

# [END bigtable_reads_row_partial]

# [START bigtable_reads_rows]
def reads_rows project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  table.read_rows(keys: ["phone#4c410523#20190501", "phone#4c410523#20190502"]).each do |row|
    print_row row
  end
end

# [END bigtable_reads_rows]

# [START bigtable_reads_row_range]
def reads_row_range project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  range = table.new_row_range.between "phone#4c410523#20190501", "phone#4c410523#201906201"
  table.read_rows(ranges: range).each do |row|
    print_row row
  end
end

# [END bigtable_reads_row_range]

# [START bigtable_reads_row_ranges]
def reads_row_ranges project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  ranges = []
  ranges <<
    table.new_row_range.between("phone#4c410523#20190501", "phone#4c410523#201906201")
  table.new_row_range.between "phone#5c10102#20190501", "phone#5c10102#201906201"
  table.read_rows(ranges: ranges).each do |row|
    print_row row
  end
end

# [END bigtable_reads_row_ranges]

# [START bigtable_reads_prefix]
def reads_prefix project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  prefix = "phone#"
  range = table.new_row_range.between prefix, prefix.next
  table.read_rows(ranges: range).each do |row|
    print_row row
  end
end

# [END bigtable_reads_prefix]

# [START bigtable_reads_filter]
def reads_filter project_id, instance_id, table_id
  bigtable = Google::Cloud::Bigtable.new project_id: project_id
  table = bigtable.table instance_id, table_id

  filter = Google::Cloud::Bigtable::RowFilter.value "PQ2A.*$"
  table.read_rows(filter: filter).each do |row|
    print_row row
  end
end

# [END bigtable_reads_filter]

# [START bigtable_reads_row]
# [START bigtable_reads_row_partial]
# [START bigtable_reads_rows]
# [START bigtable_reads_row_range]
# [START bigtable_reads_row_ranges]
# [START bigtable_reads_prefix]
# [START bigtable_reads_filter]

def print_row row
  puts "Reading data for #{row.key}"

  row.cells.each do |column_family, data|
    puts "Column Family #{column_family}"
    data.each do |cell|
      labels = cell.labels.length ? ` [#{cell.labels.join ","}]` : ""
      puts "\t#{cell.qualifier}: #{cell.value} #{cell.timestamp}#{labels}"
    end
    puts "\n"
  end
end

# [END bigtable_reads_row]
# [END bigtable_reads_row_partial]
# [END bigtable_reads_rows]
# [END bigtable_reads_row_range]
# [END bigtable_reads_row_ranges]
# [END bigtable_reads_prefix]
# [END bigtable_reads_filter]
