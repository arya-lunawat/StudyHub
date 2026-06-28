<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('doubt_replies', function (Blueprint $table) {
            $table->id();
            $table->integer('doubt_id');
            $table->string('user_token');
            $table->string('user_name');
            $table->longText('reply_text');
            $table->boolean('is_teacher')->default(false);
            $table->timestamps();
            
            $table->index('doubt_id');
            $table->index('user_token');
            $table->index('is_teacher');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('doubt_replies');
    }
};