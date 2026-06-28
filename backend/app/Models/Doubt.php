<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Doubt extends Model
{
    protected $fillable = [
        'course_id',
        'user_token',
        'user_name',
        'doubt_text'
    ];

    protected $table = 'doubts';
    public $timestamps = true;

    /**
     * Get all replies for this doubt
     */
    public function replies()
    {
        return $this->hasMany(DoubtReply::class, 'doubt_id');
    }
}
