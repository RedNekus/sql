<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class MagicCards extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('color_lst', function (Blueprint $table) {
			$table->increments('color_id')->unsigned();
			$table->string('color_name');
			$table->string('color_code');
		});
        Schema::create('rarity_lst', function (Blueprint $table) {
			$table->increments('rarity_id')->unsigned();
			$table->string('rarity_name');
			$table->string('rarity_code');
		});
        Schema::create('lang_lst', function (Blueprint $table) {
			$table->increments('lang_id')->unsigned();
			$table->string('lang_name');
			$table->string('lang_code');
		});
        Schema::create('condition_lst', function (Blueprint $table) {
			$table->increments('condition_id')->unsigned();
			$table->string('condition_name');
		});
        Schema::create('sets_lst', function (Blueprint $table) {
			$table->increments('sets_id')->unsigned();
			$table->string('sets_name');
		});
		Schema::create('magic_cards', function (Blueprint $table) {
			$table->increments('id')->unsigned();
			$table->string('name');//название карты
			$table->string('type');//тип карты или позголовок
			$table->string('image');//изображение
			$table->integer('color')->unsigned();//цвет
			$table->integer('rarity')->unsigned();//редкость
			$table->integer('lang')->unsigned();//язык
			$table->integer('condition')->unsigned();//состоние
			$table->boolean('in_stock');//в наличии
			$table->float('price');//цена
			$table->boolean('foil');//фольгирование
			$table->integer('sets')->unsigned();//сеты
			$table->text('decription');//описание
			$table->integer('amount');//количество
			$table->timestamps();
			
			$table->foreign('color')->references('color_id')->on('color_lst');
			$table->foreign('rarity')->references('rarity_id')->on('rarity_lst');
			$table->foreign('lang')->references('lang_id')->on('lang_lst');
			$table->foreign('condition')->references('condition_id')->on('condition_lst');
			$table->foreign('sets')->references('sets_id')->on('sets_lst');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('magic_cards', function (Blueprint $table) {
            Schema::drop('magic_cards');
        });
    }
}
