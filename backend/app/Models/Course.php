<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Course extends Model
{
    use HasFactory;

    /**
     * Get the course type that owns this course.
     */
    public function courseType(): BelongsTo
    {
        return $this->belongsTo(CourseType::class, 'type_id', 'id');
    }
}
