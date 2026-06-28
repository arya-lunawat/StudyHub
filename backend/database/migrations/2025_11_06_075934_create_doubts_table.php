<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('doubts', function (Blueprint $table) {
            $table->id();
            $table->integer('course_id');
            $table->string('user_token');
            $table->string('user_name');
            $table->longText('doubt_text');
            $table->timestamps();
            
            $table->index('course_id');
            $table->index('user_token');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('doubts');
    }
};