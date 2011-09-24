# -*- coding: UTF-8 -*-
require 'spec_helper'

describe ProjectsHelper do
  describe '#sort_link' do

    # --
    # share examples
    # --
    %w(project category score project_cnt).each do |col|
      shared_examples_for("deactive_link_#{col}") { deactive_link(col) }
      shared_examples_for("active_link_#{col}") { |sort_type| active_link(col, sort_type) }
    end

    def self.deactive_link(col)
      subject { sort_link(col) }
      let(:url) { controller.params[:controller] == 'categories' ? 'categories' : 'projects_list' }
      it { should have_selector('a') }
      it { should_not have_selector('a.active_sort') }
      it { should have_link(col, :href => "/#{url}?order=#{col}_a") }
    end

    def self.active_link(col, sort_type)
      subject { sort_link(col) }
      let(:url) { controller.params[:controller] == 'categories' ? 'categories' : 'projects_list' }
      let(:mark) { sort_type == 'asc' ? MARK_ASC : MARK_DESC }
      let(:order) { sort_type == 'asc' ? 'd' : 'a'}
      it {should have_selector('a.active_sort') }
      it { should have_link("#{col}#{mark}", :href => "/#{url}?order=#{col}_#{order}") }
    end

    # --
    # testing methods
    # --
    describe 'listing projects' do
      before { controller.params = {:order => ''} }
      context '初期表示の場合: when params[:order] is blank' do
        it_should_behave_like 'deactive_link_project'
        it_should_behave_like 'deactive_link_category'
        it_should_behave_like 'active_link_score', 'desc'
      end

      describe '２回目以降の場合: when params[:order] is presence' do
        context 'order is project_d' do
          before { controller.params = {:order => 'project_d'} }
          it_should_behave_like 'active_link_project', 'desc'
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'deactive_link_score'
        end
        context 'order is project_a' do
          before { controller.params = {:order => 'project_a'} }
          it_should_behave_like 'active_link_project', 'asc'
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'deactive_link_score'
        end

        context 'order is category_d' do
          before { controller.params = {:order => 'category_d'} }
          it_should_behave_like 'deactive_link_project'
          it_should_behave_like 'active_link_category', 'desc'
          it_should_behave_like 'deactive_link_score'
        end
        context 'order is category_a' do
          before { controller.params = {:order => 'category_a'} }
          it_should_behave_like 'deactive_link_project'
          it_should_behave_like 'active_link_category', 'asc'
          it_should_behave_like 'deactive_link_score'
        end

        context 'order is score_d' do
          before { controller.params = {:order => 'score_d'} }
          it_should_behave_like 'deactive_link_project'
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'active_link_score', 'desc'
        end
        context 'order is score_a' do
          before { controller.params = {:order => 'score_a'} }
          it_should_behave_like 'deactive_link_project'
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'active_link_score', 'asc'
        end
      end
    end

    describe 'listing categories' do
      before { controller.params = {:controller => 'categories'} }
      context '初期表示の場合: when params[:order] is blank' do
        before { controller.params.merge!({:order => ""}) }
        it_should_behave_like 'active_link_category', 'asc'
        it_should_behave_like 'deactive_link_project_cnt'
      end

      describe '２回目以降の場合: when params[:order] is presence' do
        context "order is category_d" do
          before { controller.params.merge!({:order => 'category_d'}) }
          it_should_behave_like 'active_link_category', 'desc'
          it_should_behave_like 'deactive_link_project_cnt'
        end
        context "order is category_a" do
          before { controller.params.merge!({:order => 'category_a'}) }
          it_should_behave_like 'active_link_category', 'asc'
          it_should_behave_like 'deactive_link_project_cnt'
        end

        context "order is project_cnt_d" do
          before { controller.params.merge!({:order => 'project_cnt_d'}) }
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'active_link_project_cnt', 'desc'
        end
        context "order is project_cnt_a" do
          before { controller.params.merge!({:order => 'project_cnt_a'}) }
          it_should_behave_like 'deactive_link_category'
          it_should_behave_like 'active_link_project_cnt', 'asc'
        end
      end
    end
  end
end
