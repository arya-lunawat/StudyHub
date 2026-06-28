<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        //Schema::table('course_types', function (Blueprint $table) {
            //if (!Schema::hasColumn('course_types', 'order')) {
                //$table->integer('order')->default(0);
            //}
        //});
    }

    public function down(): void
    {
        //Schema::table('course_types', function (Blueprint $table) {
            //if (Schema::hasColumn('course_types', 'order')) {
                //$table->dropColumn('order');
            //}
        //});
    }
};
