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
    Schema::table('course_types', function (Blueprint $table) {
        if (!Schema::hasColumn('course_types', 'parent_id')) {
            $table->unsignedBigInteger('parent_id')->default(0);
        }
        if (!Schema::hasColumn('course_types', 'title')) {
            $table->string('title')->nullable();
        }
        if (!Schema::hasColumn('course_types', 'description')) {
            $table->text('description')->nullable();
        }
        if (!Schema::hasColumn('course_types', 'order')) {
            $table->integer('order')->default(0);
        }
    });
}


    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
{
    Schema::table('course_types', function (Blueprint $table) {
        $table->dropColumn(['parent_id', 'title', 'order']);
    });
}
};
