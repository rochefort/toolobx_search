# -*- coding: UTF-8 -*-
require 'spec_helper'

describe ProjectsHelper do
  describe '#active_sort' do
    before do
      #let(:aactive_val){ Hash.new(:class => 'active_sort') }
      @active_val = { :class => 'active_sort' }
    end

    describe 'search projects' do
      context '初期表示の場合: when params[:order] is blank' do
        before { controller.params = {:order => ""} }
        it { active_sort('project_d').should == {} }
        it { active_sort('project_a').should == {} }
        it { active_sort('category_d').should == {} }
        it { active_sort('category_a').should == {} }
        it { active_sort('score_d').should == @active_val }
        it { active_sort('score_a').should == {} }
      end

      describe '２回目以降の場合: when params[:order] is presence' do
        context "project_d" do
          before { controller.params = {:order => "project_d"} }
          it { active_sort('project_d').should == @active_val }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == {} }
          it { active_sort('category_a').should == {} }
          it { active_sort('score_d').should == {} }
          it { active_sort('score_a').should == {} }
        end
        context "project_a" do
          before { controller.params = {:order => "project_a"} }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == @active_val }
          it { active_sort('category_d').should == {} }
          it { active_sort('category_a').should == {} }
          it { active_sort('score_d').should == {} }
          it { active_sort('score_a').should == {} }
        end

        context "category_d" do
          before { controller.params = {:order => "category_d"} }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == @active_val }
          it { active_sort('category_a').should == {} }
          it { active_sort('score_d').should == {} }
          it { active_sort('score_a').should == {} }
        end
        context "category_a" do
          before { controller.params = {:order => "category_a"} }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == {} }
          it { active_sort('category_a').should == @active_val }
          it { active_sort('score_d').should == {} }
          it { active_sort('score_a').should == {} }
        end

        context "score_d" do
          before { controller.params = {:order => "score_d"} }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == {} }
          it { active_sort('category_a').should == {} }
          it { active_sort('score_d').should == @active_val }
          it { active_sort('score_a').should == {} }
        end
        context "score_a" do
          before { controller.params = {:order => "score_a"} }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == {} }
          it { active_sort('category_a').should == {} }
          it { active_sort('score_d').should == {} }
          it { active_sort('score_a').should == @active_val }
        end

        describe "異常系" do
          context "querystring不正" do
            before { controller.params = {:order => "category_x"} }
            it { active_sort('project_d').should == {} }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == {} }
            it { active_sort('score_d').should == {} }
            it { active_sort('score_a').should == {} }
          end        
        end
      end

      describe 'search categories' do
        before do
          controller.params = {:controller => "categories"}
        end
        context '初期表示の場合: when params[:order] is blank' do
          before { controller.params.merge!({:order => ""}) }
          it { active_sort('project_d').should == {} }
          it { active_sort('project_a').should == {} }
          it { active_sort('category_d').should == @active_val }
          it { active_sort('category_a').should == {} }
        end

        describe '２回目以降の場合: when params[:order] is presence' do
          context "project_d" do
            before { controller.params.merge!({:order => "project_d"}) }
            it { active_sort('project_d').should == @active_val }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == {} }
          end
          context "project_a" do
            before { controller.params.merge!({:order => "project_a"}) }
            it { active_sort('project_d').should == {} }
            it { active_sort('project_a').should == @active_val }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == {} }
          end

          context "category_d" do
            before { controller.params.merge!({:order => "category_d"}) }
            it { active_sort('project_d').should == {} }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == @active_val }
            it { active_sort('category_a').should == {} }
          end
          context "category_a" do
            before { controller.params.merge!({:order => "category_a"}) }
            it { active_sort('project_d').should == {} }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == @active_val }
          end
        end
        describe "異常系" do
          context "querystring不正" do
            before { controller.params.merge!({:order => "category_x"}) }
            it { active_sort('project_d').should == {} }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == {} }
          end        

          context "controllerパラメータ不正：categoriesが未セット" do
            before { controller.params = {:order => "project_d"} }
            it { active_sort('project_d').should == @active_val }
            it { active_sort('project_a').should == {} }
            it { active_sort('category_d').should == {} }
            it { active_sort('category_a').should == {} }
          end        

        end
      end
    end
  end
end
