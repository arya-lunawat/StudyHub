<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Encore\Admin\Traits\ModelTree;

class CourseType extends Model
{
    use HasFactory;
    use ModelTree;

    /**
     * Get all courses that belong to this course type.
     */
    public function courses(): HasMany
    {
        return $this->hasMany(Course::class, 'type_id', 'id');
    }
}
