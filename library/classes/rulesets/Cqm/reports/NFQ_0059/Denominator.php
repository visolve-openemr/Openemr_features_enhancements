<?php
/**
 * Copyright (C) 2016 Visolve <services@visolve.com>
 *
 *
 * @package OpenEMR - MU2
 * @author  ViSolve Inc <services@visolve.com>
 * @link    http://www.visolve.com
 */

class NFQ_0059_Denominator implements CqmFilterIF
{
	public function getTitle() {
		return "NQF 0059 Denominator";
	}

	public function test( CqmPatient $patient, $beginDate, $endDate )
	{
		// Same as IPP
		return true ;
	}
}

?>