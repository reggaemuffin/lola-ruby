require 'spec_helper'

RSpec.describe Lola do
  describe 'general lola module' do
    it 'has a version number' do
      expect(Lola::VERSION).not_to be nil
    end

    it 'monkey patches Symbol' do
      ensure_that :s.respond_to? :query_inspect
      ensure_that Symbol.include? Lola::Joinable
    end
  end


  describe 'query building' do
    describe 'smoke tests' do
      it 'does not raise any exception on basic +' do
        :s + :d
      end

      it 'does not raise any exception on chained queries' do
        :s + :d + :x + :something
      end

      it 'does not raise any exception on being inspected' do
        (:s + :d).inspect
      end

      it 'does not raisa any exception on custom operator ⇒' do
        :d.⇒(:hehe)
      end
    end

    describe 'query string tests' do
      it 'can print (s + d)' do
        expect(
            (:s + :d).inspect
        ).to eq '(s + d)'
      end

      it 'can print (s ⇒ d)' do
        expect(
            (:s.⇒ :d).inspect
        ).to eq '(s ⇒ d)'
      end

      it 'can print (((s + d) + x) + something)' do
        expect(
            (:s + :d + :x + :something).inspect
        ).to eq '(((s + d) + x) + something)'
      end

      it 'can print ((s + d) + (x + something))' do
        expect(
            ((:s + :d) + (:x + :something)).inspect
        ).to eq '((s + d) + (x + something))'
      end
    end
  end

  describe 'query evaluation' do
    describe 'smoke tests' do
      it 'does not raise any exceptions on basic +' do
        (:s + :d).evaluate(s: 1, d: 2)
      end

      it 'raises evaluate errors on type problems' do
        expect {
          (:s + :d).evaluate(s: 1, d: 'd')
        }.to raise_error Lola::EvaluationError
      end

      it 'raises evaluate errors on operator problems' do
        expect {
          (:s.⇒ :d).evaluate(s: 1, d: 1)
        }.to raise_error Lola::EvaluationError
      end
    end

    describe 'result tests' do
      it 'calculates 1 + 2 = 3' do
        expect(
          (:s + :d).evaluate(s: 1, d: 2)
        ).to be 3
      end
    end
  end
end