!SLIDE master
# イテレーション #1 #############################################################
## "RepeaterHub クラスを作る"


!SLIDE bullets small
# 最初の一歩 ###################################################################

	@@@ ruby
	# ./spec/repeater-hub_spec.rb
	
	
	# テスト用ヘルパーライブラリの読み込み
	require File.join(File.dirname(__FILE__), "spec_helper")
	
	
	describe RepeaterHub do
	  # ここにリピータハブが持つべき「機能」を書くと、
	  # 機能テストが実行される
	end

* ※ 細かい文法は後で説明します


!SLIDE commandline bullets incremental small
# Test First ###################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	/home/yasuhito/play/trema/spec/repeater-hub_spec.rb:4: uninitialized constant RepeaterHub (NameError)
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load_spec_files'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `map'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/configuration.rb:419:in `load_spec_files'
	from /var/lib/gems/1.8/gems/rspec-core-2.6.3/lib/rspec/core/command_line.rb:18:in `run'
	  ...
	
	
	#=> FAIL ("RepeaterHub" is now known)

* 失敗は予想通り (まだ何も実装していないし)
* テストを通す最低限の実装を追加しよう


!SLIDE small
# テストを通すための修正 ########################################################

	@@@ ruby
	require File.join( File.dirname( __FILE__ ), "spec_helper" )
	
	
	# 空のクラス定義を追加し、NameError が起こらないようにする
	class RepeaterHub
	end
	

	describe RepeaterHub do
	end


!SLIDE commandline bullets small
# ふたたびテスト ################################################################

	@@@ commandline
	$ rspec -fs -c spec/repeater-hub_spec.rb 
	No examples found.
	
	Finished in 0.00003 seconds
	0 examples, 0 failures
	
	
	#=> SUCCESS

* RepeaterHub とテストのひながたができた
* イテレーション #1 終了


!SLIDE bullets incremental small
# RSpec ########################################################################

* Ruby の標準的なユニットテストフレームワーク
* Rails など有名プロジェクトで採用
* 読みやすいテスト DSL (後述)
* describe "クラス名" do ... end にクラスの機能 (= スペック) を記述


!SLIDE bullets small incremental
# Why Test First? ##############################################################

* 複雑なプログラミングにはテストによるインクリメンタルな開発が有効
* Ruby プログラマはテストファーストが好き (Test::Unit, RSpec etc.)
* Trema は RSpec に OpenFlow 拡張を追加
