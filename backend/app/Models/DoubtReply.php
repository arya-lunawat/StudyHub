<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DoubtReply extends Model
{
    protected $fillable = [
        'doubt_id',
        'user_token',
        'user_name',
        'reply_text',
        'is_teacher'
    ];

    protected $table = 'doubt_replies';
    public $timestamps = true;

    /**
     * Get the doubt this reply belongs to
     */
    public function doubt()
    {
        return $this->belongsTo(Doubt::class, 'doubt_id');
    }
}
