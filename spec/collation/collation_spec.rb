if mysql_awesome_enabled?
  describe 'Ridgepole::Client#diff -> migrate' do
    context 'when change column (add collation)' do
      let(:actual_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false
            t.text    "text",    null: false
          end
        RUBY
      }

      let(:expected_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false,                 collation: "ascii_bin"
            t.text    "text",    null: false,                 collation: "utf8mb4_bin"
          end
        RUBY
      }

      before { subject.diff(actual_dsl).migrate }
      subject { client }

      it {
        delta = subject.diff(expected_dsl)
        expect(delta.differ?).to be_truthy
        expect(subject.dump).to eq actual_dsl.strip_heredoc.strip
        delta.migrate
        expect(subject.dump).to eq expected_dsl.strip_heredoc.strip
      }
    end

    context 'when change column (delete collation)' do
      let(:actual_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false,                 collation: "ascii_bin"
            t.text    "text",    null: false,                 collation: "utf8mb4_bin"
          end
        RUBY
      }

      let(:expected_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false
            t.text    "text",    null: false
          end
        RUBY
      }

      before { subject.diff(actual_dsl).migrate }
      subject { client }

      it {
        delta = subject.diff(expected_dsl)
        expect(delta.differ?).to be_truthy
        expect(subject.dump).to eq actual_dsl.strip_heredoc.strip
        delta.migrate
        expect(subject.dump).to eq expected_dsl.strip_heredoc.strip
      }
    end

    context 'when change column (change collation)' do
      let(:actual_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false,                 collation: "ascii_bin"
            t.text    "text",    null: false,                 collation: "utf8mb4_bin"
          end
        RUBY
      }

      let(:expected_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false,                 collation: "utf8mb4_bin"
            t.text    "text",    null: false,                 collation: "ascii_bin"
          end
        RUBY
      }

      before { subject.diff(actual_dsl).migrate }
      subject { client }

      it {
        delta = subject.diff(expected_dsl)
        expect(delta.differ?).to be_truthy
        expect(subject.dump).to eq actual_dsl.strip_heredoc.strip
        delta.migrate
        expect(subject.dump).to eq expected_dsl.strip_heredoc.strip
      }
    end

    context 'when change column (no change collation)' do
      let(:actual_dsl) {
        <<-RUBY
          create_table "employee_clubs", force: true do |t|
            t.integer "emp_no",  null: false
            t.integer "club_id", null: false, unsigned: true
            t.string  "string",  null: false,                 collation: "ascii_bin"
            t.text    "text",    null: false,                 collation: "utf8mb4_bin"
          end
        RUBY
      }

      before { subject.diff(actual_dsl).migrate }
      subject { client }

      it {
        delta = subject.diff(actual_dsl)
        expect(delta.differ?).to be_falsey
        expect(subject.dump).to eq actual_dsl.strip_heredoc.strip
        delta.migrate
        expect(subject.dump).to eq actual_dsl.strip_heredoc.strip
      }
    end
  end
end
