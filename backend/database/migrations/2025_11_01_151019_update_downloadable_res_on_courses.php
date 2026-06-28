<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
{
    //Schema::table('courses', function (Blueprint $table) {
        // Make it nullable or set a default value
        //$table->string('downloadable_res')->nullable()->change();
        // OR use default value:
        // $table->string('downloadable_res')->default('')->change();
    //});
}

public function down()
{
    //Schema::table('courses', function (Blueprint $table) {
        //$table->string('downloadable_res')->change();
   // });
}

};
