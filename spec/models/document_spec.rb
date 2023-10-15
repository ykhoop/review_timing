require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'バリデーション' do
    context 'コード、説明、内容がある場合' do
      it 'ドキュメントを登録できる' do
        document = FactoryBot.build(:document)
        expect(document).to be_valid
      end
    end

    context 'コードがない場合' do
      it 'ドキュメントを登録できない' do
        document = FactoryBot.build(:document, code: nil)
        expect(document).to be_invalid
        document = FactoryBot.build(:document, code: '')
        expect(document).to be_invalid
      end
    end

    context 'コードが重複している場合' do
      it 'ドキュメントを登録できない' do
        document = FactoryBot.create(:document)
        document2 = FactoryBot.build(:document, code: document.code)
        expect(document2).to be_invalid
      end
    end

    context '説明がない場合' do
      it 'ドキュメントを登録できない' do
        document = FactoryBot.build(:document, description: nil)
        expect(document).to be_invalid
        document = FactoryBot.build(:document, description: '')
        expect(document).to be_invalid
      end
    end

    context '内容がない場合' do
      it 'ドキュメントを登録できない' do
        document = FactoryBot.build(:document, content: nil)
        expect(document).to be_invalid
        document = FactoryBot.build(:document, content: '')
        expect(document).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    describe 'contact_url' do
      it 'お問い合わせの内容を返す' do
        FactoryBot.create(:document_with_additional_documents)
        document = Document.find_by(code: 'contact')
        expect(Document.contact_url).to eq document.content
      end
    end
  end
end
