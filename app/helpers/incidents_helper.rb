module IncidentsHelper
  ASC_SORT = 'asc'
  DESC_SORT = 'desc'

  def sort_link(column:, label:)
    if column == params[:column]
      link_to(label, list_incidents_path(column: column, sort: next_sort))
    else
      link_to(label, list_incidents_path(column: column, sort: ASC_SORT))
    end
  end

  def sort_indicator
    if params[:sort] == ASC_SORT
      '<svg class="w-[15px] h-[15px] text-gray-800 dark:text-white mr-[15px]" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 8">
        <path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7 7.674 1.3a.91.91 0 0 0-1.348 0L1 7"/>
      </svg>'.html_safe
    elsif params[:sort] == DESC_SORT
      '<svg class="w-[15px] h-[15px] text-gray-800 dark:text-white mr-[15px]" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 8">
        <path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 5.326 5.7a.909.909 0 0 0 1.348 0L13 1"/>
      </svg>'.html_safe
    end
  end

  def next_sort
    params[:sort] == ASC_SORT ? DESC_SORT : ASC_SORT
  end
end
