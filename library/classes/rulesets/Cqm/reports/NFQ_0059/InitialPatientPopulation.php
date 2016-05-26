<?php
/**
 * Copyright (C) 2016 Visolve <services@visolve.com>
 *
 *
 * @package OpenEMR - MU2
 * @author  ViSolve Inc <services@visolve.com>
 * @link    http://www.visolve.com
 */

class NFQ_0059_InitialPatientPopulation implements CqmFilterIF
{
    public function getTitle() 
    {
        return "Initial Patient Population";
    }
    
    public function test( CqmPatient $patient, $beginDate, $endDate ) 
    {
    	$age = $patient->calculateAgeOnDate( $beginDate );
        if ( $age >= 18 && $age < 75 && Helper::check( ClinicalType::ENCOUNTER, Encounter::ENC_OFF_VIS, $patient, $beginDate, $endDate)) {
            
        	$diabetes_codes = array();
        	foreach(Codes::lookup(Diagnosis::DIABETES,'SNOMED-CT') as $code){ $diabetes_codes[] = "SNOMED-CT:".$code;}
        	$diabetes_codes = "'".implode("','",$diabetes_codes)."'";
        	
        	$query = "select count(*) cnt from form_encounter fe ".
          			 "inner join lists l on ( l.type='medical_problem' and l.pid = fe.pid )".
          			 "where fe.pid = ? and fe.date between ? and ? ".
          			 "and l.diagnosis in ($diabetes_codes) and (l.begdate < ? or (l.begdate between ? and ? )) and (l.enddate is null or l.enddate > ? )";
        	
        	$sql = sqlQuery($query,array($patient->id,$beginDate,$endDate,$beginDate,$beginDate,$endDate,$endDate));
        	if($sql['cnt'] > 0) return true;
        	
        	return false;
        }
        
        return false;
    }
}
?>
