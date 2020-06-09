require 'rails_helper'

describe MessagesController do
  #  letを利用してテスト中使用するインスタンスを定義：テストを高速化する ＝ 遅延評価
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    context 'log in' do
      # 毎回処理を行う
      before do
        login user
        # messageはgroupにルーティングネストされているためgroupを含んだparamsを渡す
        get :index, params: { group_id: group.id }
      end

      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
      end

      it 'assigns @group' do
        expect(assigns(:group)).to eq group
      end

      it 'renders index' do
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    # letでparamsを定義：内容 group_id, user_id, 象徴の形でmessegeのオブジェクトを生成
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
    #loginしているかいなか
    context 'log in' do
      before do
        login user
      end

      context 'can save' do
        # subjectにcreateで生成したletで定義したparamsを生成
        subject {
          post :create,
          params: params
        }

        it 'count up message' do
          # subjectに先ほどのparamsの値を代入して、Messageモデルのレコードのcountが1増えたかどうか？
          expect{ subject }.to change(Message, :count).by(1)
        end

        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, text: nil, image: nil) } }

        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          # not_to changeでto changeの逆になる
          expect{ subject }.not_to change(Message, :count)
        end

        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do

      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end